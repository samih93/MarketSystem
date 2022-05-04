import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  UserCredential? _user = null;
  UserCredential? get user => _user;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    _user = await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
    return _user!;
  }

  Future<void> google_signOut() async {
    await _googleSignIn.signOut().then((value) {
      _user = null;
      notifyListeners();
      print(_user?.user?.displayName);
    });
  }

  String? getDrawerTitle() =>
      _user == null ? "SIGN IN" : _user?.user?.displayName.toString();
  String? getDrawerSubTitle() =>
      _user == null ? "Synchronization disabled" : "Synchronization enabled";
}
