import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Uploader {
  static Future<String> uploadImage(
      {String? destination, String? id, PlatformFile? platformFile}) async {
    final storageRef = FirebaseStorage.instance.ref();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // Upload file and metadata to the path 'images/mountains.jpg'
    UploadTask uploadTask = storageRef
        .child("$destination/$id/photo_$fileName.${platformFile!.extension}")
        .putData(platformFile.bytes!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  static Future<String> uploadDocument(
      {String? destination, String? id, PlatformFile? platformFile}) async {
    final storageRef = FirebaseStorage.instance.ref();

    // String fName = ;

    // String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    UploadTask uploadTask = storageRef
        .child("$destination/$id/${platformFile!.name}")
        .putData(platformFile.bytes!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  static Future<String> deleteFileFromStorage({required String url}) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
      return "success";
    } catch (e) {
      print(e.toString());
      return url;
    }
  }
}
