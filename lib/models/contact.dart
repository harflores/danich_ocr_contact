/// Modelo de datos para un Contacto
class Contact {
  int? id;                // ID del contacto (clave primaria en la base de datos)
  String nombre;
  String empresa;
  String cargo;
  String correo;
  String telefono;
  String direccion;

  Contact({
    this.id,
    required this.nombre,
    required this.empresa,
    required this.cargo,
    required this.correo,
    required this.telefono,
    required this.direccion,
  });

  /// Constructor para crear Contact desde un Map (por ejemplo, de la base de datos)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      nombre: map['nombre'] ?? '',
      empresa: map['empresa'] ?? '',
      cargo: map['cargo'] ?? '',
      correo: map['correo'] ?? '',
      telefono: map['telefono'] ?? '',
      direccion: map['direccion'] ?? '',
    );
  }

  /// Convierte este Contact a Map (por ejemplo, para insertar en base de datos o convertir a JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'empresa': empresa,
      'cargo': cargo,
      'correo': correo,
      'telefono': telefono,
      'direccion': direccion,
    };
  }
}
