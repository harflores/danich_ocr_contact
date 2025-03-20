# danich_ocr_contact

Este es un proyecto de Flutter que permite escanear tarjetas de contacto utilizando la cámara del dispositivo, reconocer el texto mediante ML Kit, y almacenar la información extraída en una base de datos local. Además, ofrece la funcionalidad de exportar los contactos a un archivo JSON y enviarlos por correo electrónico.

## Características

- **Escaneo de Tarjetas de Contacto**: Utiliza la cámara del dispositivo para capturar imágenes de tarjetas de contacto.
- **Reconocimiento de Texto**: Implementa Google ML Kit para extraer texto de las imágenes capturadas.
- **Almacenamiento Local**: Guarda los contactos en una base de datos SQLite local.
- **Gestión de Contactos**: Permite agregar, editar y eliminar contactos.
- **Exportación y Envío por Correo**: Exporta los contactos a un archivo JSON y prepara un correo electrónico para enviarlos.

## Requisitos Previos

- Flutter SDK
- Android Studio o Visual Studio Code
- Dispositivo o emulador con cámara

## Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/harflores/danich_ocr_contact.git
   ```
2. Navega al directorio del proyecto:
   ```bash
   cd danich_ocr_contact
   ```
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```

## Uso

1. Conecta un dispositivo o inicia un emulador.
2. Ejecuta la aplicación:
   ```bash
   flutter run
   ```
3. Usa la aplicación para escanear tarjetas de contacto y gestionar tus contactos.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o un pull request para discutir cualquier cambio que desees realizar.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## Contacto

Para cualquier consulta, puedes contactarme en [tu_email@ejemplo.com](mailto:tu_email@ejemplo.com).
