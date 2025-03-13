import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../models/contact.dart';
import 'contact_form_screen.dart';
import 'camera_screen.dart';
import '../services/export_service.dart'; // servicio para exportar JSON y enviar correo

class ContactsListScreen extends StatelessWidget {
  const ContactsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider de contactos para acceder a la lista y acciones
    final contactProvider = Provider.of<ContactProvider>(context);
    final contacts = contactProvider.contacts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Contactos'),
        actions: [
          IconButton(
            icon: Icon(Icons.email),
            tooltip: 'Exportar y Enviar',
            onPressed: () async {
              // Exportar contactos a JSON y enviar por correo
              bool success = await ExportService.exportContactsToEmail(contacts);
              String msg = success ? 'Exportación exitosa, correo preparado.' 
                                    : 'Error al exportar contactos.';
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
            },
          )
        ],
      ),
      body: contacts.isEmpty 
        ? Center(child: Text('No hay contactos guardados.'))
        : ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              Contact contact = contacts[index];
              return ListTile(
                title: Text(contact.nombre),
                subtitle: Text(contact.empresa),
                onTap: () {
                  // Ver/editar contacto existente: navegar a ContactFormScreen en modo edición
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ContactFormScreen(contact: contact)
                  ));
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Eliminar contacto
                    contactProvider.deleteContact(contact.id!);
                  },
                ),
              );
            },
          ),
      floatingActionButton: PopupMenuButton<String>(
        // Botón flotante que muestra opciones de agregar
        onSelected: (value) {
          if (value == 'camera') {
            // Navegar a la pantalla de cámara para agregar mediante foto
            Navigator.push(context, MaterialPageRoute(builder: (_) => CameraScreen()));
          } else if (value == 'manual') {
            // Navegar a formulario vacío para agregar manualmente
            Navigator.push(context, MaterialPageRoute(builder: (_) => ContactFormScreen()));
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'camera', child: Text('Agregar desde Cámara')),
          PopupMenuItem(value: 'manual', child: Text('Agregar Manualmente')),
        ],
        child: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Agregar contacto',
          onPressed: null, // onPressed no se usa porque PopupMenuButton lo gestiona
        ),
      ),
    );
  }
}
