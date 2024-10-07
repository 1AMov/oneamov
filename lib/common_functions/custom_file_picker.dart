import 'package:file_picker/file_picker.dart';

class CustomFilePicker {
  static Future<List<PlatformFile>> pickImages({bool? isMultiple}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: isMultiple ?? false, type: FileType.image, withData: true);

    return result != null ? result.files : [];
  }

  static Future<List<PlatformFile>> pickDocuments(
      {required bool isMultiple,
      FileType fileType = FileType.any,
      List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: isMultiple,
        allowedExtensions: allowedExtensions,
        type: fileType,
        withData: true);

    return result != null ? result.files : [];
  }
}
