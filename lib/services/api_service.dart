import '../models/contact.dart';

class ApiService {

  /// Envía el texto reconocido al servidor de IA y devuelve un Contact con la info extraída.
  Future<Contact?> procesarTexto(String texto) async {
    try {
      if(texto.isNotEmpty){
        Contact contact = Contact(
          textCapture: texto,
        );
        return contact;
      } else {
        return null;
      }
    } catch (e) {
      print("Excepción en procesarTexto: $e");
      return null;
    }
  }
}
