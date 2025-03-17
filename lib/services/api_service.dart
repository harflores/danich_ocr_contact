import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  final String _endpoint = 'http://192.168.70.33:8093/v1/completions';

  /// Envía el texto reconocido al servidor de IA y devuelve un Contact con la info extraída.
  Future<Contact?> procesarTexto(String texto) async {
    try {
      // // Construir el cuerpo de la solicitud, enviando el texto reconocido
      // final requestBody = jsonEncode({
      //   "prompt": "Copia el $texto y ordena por nombre, empresa, cargo, correo, teléfono y dirección.",
      // });

      // final response = await http.post(
      //   Uri.parse(_endpoint),
      //   headers: {"Content-Type": "application/json"},
      //   body: requestBody,
      // );

      if(texto.isNotEmpty){
        Contact contact = Contact(
          nombre: '',
          empresa: '',
          cargo: '',
          correo: '',
          telefono: '',
          direccion: '',
          textoReconocido: texto,
        );
      // }

      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   Contact contact = Contact(
      //     nombre: data["nombre"] ?? '',
      //     empresa: data["empresa"] ?? '',
      //     cargo: data["cargo"] ?? '',
      //     correo: data["correo"] ?? '',
      //     telefono: data["telefono"] ?? '',
      //     direccion: data["direccion"] ?? '',
      //     textoReconocido: texto,
      //   );
        return contact;
      } else {
        // print("Error API: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción en procesarTexto: $e");
      return null;
    }
  }
}
