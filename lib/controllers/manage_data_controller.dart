import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ManageDataController extends ChangeNotifier {
  Future<void> uploadDatabase(String token, File profile_image) async {
    FirebaseStorage.instance
        .ref('')
        .child('users/$token')
        .putFile(profile_image)
        .then((value) {
      value.ref.getDownloadURL().then((value) {}).catchError((error) {
        {
          print(error.toString());
        }
      });
    }).catchError((error) {
      print(error.toString());
    });
  }
}
