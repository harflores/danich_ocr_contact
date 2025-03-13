import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../database/database_service.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  ContactProvider() {
    // Al inicializar el provider, cargamos los contactos desde la BD
    loadContacts();
  }

  /// Cargar todos los contactos desde la base de datos
  Future<void> loadContacts() async {
    _contacts = await DatabaseService.getAllContacts();
    notifyListeners();
  }

  /// Agregar un nuevo contacto (en BD y en lista)
  Future<void> addContact(Contact contact) async {
    // Insertar en la base de datos
    int newId = await DatabaseService.insertContact(contact);
    contact.id = newId; // asignar el ID generado al objeto
    // Añadir a la lista local
    _contacts.add(contact);
    notifyListeners();
  }

  /// Editar un contacto existente
  Future<void> updateContact(Contact contact) async {
    if (contact.id == null) return;
    await DatabaseService.updateContact(contact);
    // Reemplazar el contacto en la lista local
    int index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      notifyListeners();
    }
  }

  /// Eliminar un contacto por id
  Future<void> deleteContact(int id) async {
    await DatabaseService.deleteContact(id);
    // Remover de la lista local
    _contacts.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
