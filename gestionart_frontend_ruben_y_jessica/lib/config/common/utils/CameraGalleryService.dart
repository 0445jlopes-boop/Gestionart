import 'package:image_picker/image_picker.dart';

class CameraGalleryService { // Clase que permite integrar fotos a nestra aplicación desde cámara o desde los archivos del dispositivo. Entonces selecciona (galeria) o coge (camara) foto según de donde provenga.
  final ImagePicker _picker = ImagePicker();
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo == null) return null;
    return photo.path;
  }

  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo == null) return null;

    return photo.path;
  }
}