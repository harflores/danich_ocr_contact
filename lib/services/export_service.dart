import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../models/contact.dart';

class ExportService {
  /// Exporta la lista de contactos a un archivo JSON y prepara un correo para enviar.
  /// Devuelve true si se inició el proceso correctamente.
  static Future<bool> exportContactsToEmail(List<Contact> contacts) async {
    try {
      // Convertir la lista de contactos a JSON
      List<Map<String, dynamic>> contactMaps = contacts.map((c) => c.toMap()).toList();
      String jsonString = jsonEncode(contactMaps);

      // Guardar el JSON en un archivo temporal
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/contacts_export.json';
      File file = File(filePath);
      await file.writeAsString(jsonString);

      // Preparar el correo
      final Email email = Email(
        body: 'Adjunto encontrarás el archivo JSON con los contactos exportados.',
        subject: 'Exportación de Contactos',
        recipients: [],  // Puede dejarse vacío para que el usuario elija el destinatario
        attachmentPaths: [filePath],
        isHTML: false,
      );

      // Enviar (abrir cliente de correo)
      await FlutterEmailSender.send(email);
      return true;
    } catch (e) {
      print('Error al exportar contactos: $e');
      return false;
    }
  }
}
