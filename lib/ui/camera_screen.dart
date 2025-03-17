import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/api_service.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

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

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _cameraController!.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // Función para extraer texto de la imagen utilizando ML Kit
  Future<String> _recognizeText(String imagePath) async {
    // Leer la imagen desde la ruta
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    // Concatenar todas las líneas reconocidas en un solo String
    String completeText = recognizedText.text;
    return completeText;
  }

  Future<void> _captureAndProcessImage() async {
    if (_cameraController == null) return;
    try {
      await _initializeControllerFuture;
      // Tomar la foto
      XFile file = await _cameraController!.takePicture();
      final String imagePath = file.path;
      
      // Utilizar ML Kit para reconocer el texto dentro de la imagen
      String textoReconocido = await _recognizeText(imagePath);
      print('Texto reconocido: $textoReconocido');

      // Enviar el texto reconocido a la IA para que lo analice
      ApiService apiService = ApiService();
      // Modificamos el método de la API para enviar el texto en lugar de la imagen
      Contact? newContact = await apiService.procesarTexto(textoReconocido);
      
      if (newContact != null) {
        Provider.of<ContactProvider>(context, listen: false).addContact(newContact);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contacto agregado: ${newContact.nombre}'))
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo extraer información del contacto.'))
        );
      }
    } catch (e) {
      print('Error al capturar o procesar la imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar la imagen.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_initializeControllerFuture == null)
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController!);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndProcessImage,
        tooltip: 'Tomar foto',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
