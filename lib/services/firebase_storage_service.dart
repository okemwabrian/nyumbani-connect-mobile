import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the download URL
  Future<String?> uploadImage(File image, String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
