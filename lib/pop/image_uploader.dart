import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html' as html;
//import 'package:file_picker/file_picker.dart';

/*Future<String?> pickAndUploadImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

  if (result != null) {
    html.File file = result.files.first.bytes as html.File;
    final storageRef = FirebaseStorage.instance.ref().child('images/${result.files.first.name}');
    final uploadTask = storageRef.putBlob(file);

    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  return null;
}*/

Future<String?> pickAndUploadImage() async {
  // Create an input element to select files
  final input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();

  // Wait for the user to select a file
  await input.onChange.first;

  // Get the selected file
  final file = input.files!.first;

  // Create a reference to Firebase Storage
  final storageRef = FirebaseStorage.instance.ref().child('images/${file.name}');
  
  // Upload the file to Firebase Storage
  final uploadTask = storageRef.putBlob(file);
  
  final snapshot = await uploadTask.whenComplete(() => {});
  final imageUrl = await snapshot.ref.getDownloadURL();
  return imageUrl;
  
}