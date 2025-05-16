//will allowus to get files from device library
import 'dart:io';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';

// import '../services/media_service.dart';
// import 'dart:io';

class MediaService {
  double getWidth() {
    return PlatformDispatcher.instance.views.first.physicalSize.width /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
  }

  double getHeight() {
    return PlatformDispatcher.instance.views.first.physicalSize.height /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
  }

  static MediaService instance = MediaService();

  Future<File?> getImageFromLibrary() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path); // Convert XFile to File
    }
    return null; // Return null if no image is picked
  }

  void playAudio(AudioPlayer play, String url) async {
    await play.play(UrlSource(url));
    print("playing");
  }

  void pauseAudio(AudioPlayer play) async {
    await play.pause();
    print("Paused");
  }

  void resumeAudio(AudioPlayer play) async {
    await play.resume();
    print("resuming");
  }
}
//how to get the file and use this class
//make a file variable > make it the reciver (_imageFileExample)  >then sue it normaly
// async{ (_imageFileExample) =await MediaService.instance.getImageFromLibrary();}
