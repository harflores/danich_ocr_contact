import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;
  const ContactFormScreen({Key? key, this.contact}) : super(key: key);

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  // GlobalKey para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para cada campo
  late TextEditingController _nombreController;
  late TextEditingController _empresaController;
  late TextEditingController _cargoController;
  late TextEditingController _correoController;
  late TextEditingController _telefonoController;
  late TextEditingController _direccionController;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores, usando los datos del contacto si existe
    _nombreController = TextEditingController(text: widget.contact?.nombre ?? '');
    _empresaController = TextEditingController(text: widget.contact?.empresa ?? '');
    _cargoController = TextEditingController(text: widget.contact?.cargo ?? '');
    _correoController = TextEditingController(text: widget.contact?.correo ?? '');
    _telefonoController = TextEditingController(text: widget.contact?.telefono ?? '');
    _direccionController = TextEditingController(text: widget.contact?.direccion ?? '');
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores al salir
    _nombreController.dispose();
    _empresaController.dispose();
    _cargoController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
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
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value == null || value.isEmpty ? 'Ingrese el nombre' : null,
                ),
                TextFormField(
                  controller: _empresaController,
                  decoration: InputDecoration(labelText: 'Empresa'),
                ),
                TextFormField(
                  controller: _cargoController,
                  decoration: InputDecoration(labelText: 'Cargo'),
                ),
                TextFormField(
                  controller: _correoController,
                  decoration: InputDecoration(labelText: 'Correo'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _telefonoController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _direccionController,
                  decoration: InputDecoration(labelText: 'Dirección'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(isEditing ? 'Guardar Cambios' : 'Agregar Contacto'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Crear/actualizar el objeto Contact
                      Contact newData = Contact(
                        id: widget.contact?.id,
                        nombre: _nombreController.text,
                        empresa: _empresaController.text,
                        cargo: _cargoController.text,
                        correo: _correoController.text,
                        telefono: _telefonoController.text,
                        direccion: _direccionController.text,
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
