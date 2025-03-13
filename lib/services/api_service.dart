import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  final String _endpoint = 'http://192.168.56.1:8093/v1/chat/completions';

  /// Envía la imagen al servidor de IA y devuelve un Contact con la info extraída.
  Future<Contact?> procesarImagen(String imagePath) async {
    try {
      // Leer el archivo de imagen como bytes
      final bytes = File(imagePath).readAsBytesSync();
      // Codificar la imagen en base64 (si el API espera texto JSON)
      String base64Image = base64Encode(bytes);

      // Construir el cuerpo de la solicitud. 
      // Suponemos que el API espera un JSON con la imagen en base64 o algún campo específico.
      final requestBody = jsonEncode({
        "prompt": "Extract contact info from the image",
        "image_base64": base64Image
      });

      // Realizar la solicitud POST al servidor local
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Parsear la respuesta. Suponemos que es JSON con los campos de contacto.
        final data = jsonDecode(response.body);
        // Crear objeto Contact con los datos recibidos
        Contact contact = Contact(
          nombre: data["nombre"] ?? '',
          empresa: data["empresa"] ?? '',
          cargo: data["cargo"] ?? '',
          correo: data["correo"] ?? '',
          telefono: data["telefono"] ?? '',
          direccion: data["direccion"] ?? '',
        );
        return contact;
      } else {
        print("Error API: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción en procesarImagen: $e");
      return null;
    }
  }
}
