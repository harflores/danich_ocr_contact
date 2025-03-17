/// Modelo de datos para un Contacto
class Contact {
  int? id;                // ID del contacto (clave primaria en la base de datos)
  String textCapture;

  Contact({
    this.id,
    required this.textCapture
  });

  /// Constructor para crear Contact desde un Map (por ejemplo, de la base de datos)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      textCapture: map['textCapture'] ?? '',
    );
  }

  /// Convierte este Contact a Map (por ejemplo, para insertar en base de datos o convertir a JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'textCapture': textCapture
    };
  }
}
