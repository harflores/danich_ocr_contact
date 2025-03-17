import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;
  const ContactFormScreen({super.key, this.contact});

  @override
  ContactFormScreenState createState() => ContactFormScreenState();
}

class ContactFormScreenState extends State<ContactFormScreen> {
  // GlobalKey para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para cada campo
  late TextEditingController _textoReconocidoController;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores, usando los datos del contacto si existe
    _textoReconocidoController = TextEditingController(text: widget.contact?.textCapture ?? '');
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores al salir
    _textoReconocidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Contacto' : 'Nuevo Contacto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _textoReconocidoController,
                  decoration: InputDecoration(labelText: 'Datos Contacto'),
                  maxLines: 10,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(isEditing ? 'Guardar Cambios' : 'Agregar Contacto'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Crear/actualizar el objeto Contact
                      Contact newData = Contact(
                        id: widget.contact?.id,
                        textCapture: _textoReconocidoController.text,
                      );
                      // Usar provider para guardar en BD y actualizar estado
                      final provider = Provider.of<ContactProvider>(context, listen: false);
                      if (isEditing) {
                        provider.updateContact(newData);
                      } else {
                        provider.addContact(newData);
                      }
                      Navigator.pop(context); // Volver a la pantalla anterior (lista)
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
