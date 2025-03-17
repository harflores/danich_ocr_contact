import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class DatabaseService {
  static Database? _db;

  // Nombre de la base de datos y tabla
  static const String dbName = 'contacts_db.db';
  static const String tableContacts = 'contacts';

  // Columnas de la tabla de contactos
  static const String colId = 'id';
  static const String colTextCapture = 'textCapture';

  /// Obtener instancia de la base de datos (inicializar si es necesario)
  static Future<Database> _getDatabase() async {
    if (_db != null) {
      return _db!;
    }
    // Obtener ruta del directorio de bases de datos en el dispositivo
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    // Abrir la base de datos, creando la tabla si aún no existe
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableContacts (
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colTextCapture TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  /// Insertar un contacto en la base de datos
  static Future<int> insertContact(Contact contact) async {
    final db = await _getDatabase();
    // Convertir Contact a mapa y realizar la inserción
    int id = await db.insert(tableContacts, contact.toMap());
    return id;
  }

  /// Obtener todos los contactos desde la base de datos
  static Future<List<Contact>> getAllContacts() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> results = await db.query(tableContacts);
    // Convertir cada map a Contact
    List<Contact> contacts = results.map((map) => Contact.fromMap(map)).toList();
    return contacts;
  }

  /// Actualizar un contacto existente
  static Future<int> updateContact(Contact contact) async {
    final db = await _getDatabase();
    if (contact.id == null) return 0;
    return await db.update(
      tableContacts, 
      contact.toMap(),
      where: '$colId = ?', 
      whereArgs: [contact.id],
    );
  }

  /// Eliminar un contacto por ID
  static Future<int> deleteContact(int id) async {
    final db = await _getDatabase();
    return await db.delete(
      tableContacts,
      where: '$colId = ?', 
      whereArgs: [id],
    );
  }
}
