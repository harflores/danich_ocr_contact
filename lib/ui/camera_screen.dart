import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/api_service.dart';    // Para enviar la imagen al servidor
import '../models/contact.dart';         // El modelo de contacto
import '../providers/contact_provider.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializa la cámara seleccionando la primera disponible (ej. cámara trasera)
  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras(); 
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0],           // seleccionamos la primera cámara (por lo general trasera)
        ResolutionPreset.high, // resolución alta
      );
      _initializeControllerFuture = _cameraController!.initialize();
      setState(() {}); // Actualizar el estado una vez que tenemos el Future
    }
  }

  @override
  void dispose() {
    // Liberar el controlador de la cámara cuando no se use
    _cameraController?.dispose();
    super.dispose();
  }

  // Método para capturar la foto y procesarla
  Future<void> _captureAndProcessImage() async {
    if (_cameraController == null) return;
    try {
      // Esperar a que la cámara esté inicializada
      await _initializeControllerFuture;
      // Tomar la foto (se guarda en un XFile)
      XFile file = await _cameraController!.takePicture();
      final String imagePath = file.path;
      
      // Enviar la imagen al servicio de IA y obtener un Contact (esto podría tardar unos segundos)
      ApiService apiService = ApiService();
      Contact? newContact = await apiService.procesarImagen(imagePath);
      
      if (newContact != null) {
        // Guardar el contacto en la base de datos a través del provider
        Provider.of<ContactProvider>(context, listen: false).addContact(newContact);
        // Mostrar confirmación al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contacto agregado: ${newContact.nombre}'))
        );
        // Regresar o navegar a la lista de contactos
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo extraer información del contacto.'))
        );
      }
    } catch (e) {
      print('Error al capturar/procesar la imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar la imagen.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_initializeControllerFuture == null)
          ? Center(child: CircularProgressIndicator())  // Esperando la inicialización de la cámara
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // La cámara está lista, mostrar la previsualización
                  return CameraPreview(_cameraController!);
                } else {
                  // Mientras la cámara carga, mostrar un indicador de carga
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndProcessImage,
        child: Icon(Icons.camera_alt),
        tooltip: 'Tomar foto',
      ),
    );
  }
}
