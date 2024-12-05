//will allowus to get files from device library
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// import '../services/media_service.dart';
// import 'dart:io';

class MediaService {
  static MediaService instance = MediaService();

  Future<File?> getImageFromLibrary() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path); // Convert XFile to File
    }
    return null; // Return null if no image is picked
  }
}
//how to get the file and use this class
//make a file variable > make it the reciver (_imageFileExample)  >then sue it normaly
// async{ (_imageFileExample) =await MediaService.instance.getImageFromLibrary();}