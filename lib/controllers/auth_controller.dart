import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketsystem/models/user.dart';
import 'package:marketsystem/shared/local/cash_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class AuthController extends ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

//NOTE Sign with google --------------------
  String statusLoginMessage = "";
  ToastStatus toastStatus = ToastStatus.Error;
  bool isloadingLogin = false;
  Future<void> signInWithGoogle() async {
    UserCredential? _user = null;
    GoogleSignInAccount? googleUser;

    // Trigger the authentication flow

    try {
      googleUser = await GoogleSignIn().signIn();
      isloadingLogin = true;
      statusLoginMessage = "Logged In Successfully";
      toastStatus = ToastStatus.Success;
      notifyListeners();

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

      if (_user.user != null)
        _user.user?.getIdToken().then((token) {
          _userModel = UserModel(
              displayName: _user?.user!.displayName,
              email: _user?.user!.email,
              photoURL: _user?.user!.photoURL,
              token: token);

          CashHelper.saveUser(_userModel!);
          isloadingLogin = false;
          notifyListeners();
        });
    } catch (e) {
      statusLoginMessage =
          "Logged In failed, check your network connection and try again";
      toastStatus = ToastStatus.Error;
      isloadingLogin = false;
      notifyListeners();
    }
  }

  Future<void> google_signOut() async {
    await _googleSignIn.signOut().then((value) {
      _userModel = null;
      CashHelper.removeDatabykey(key: "user");
      notifyListeners();
      // print(_user?.user?.displayName);
    });
  }

  UserModel? _userModel = null;
  UserModel? get userModel => _userModel;

  Future<void> getUserData() async {
    UserModel? user = await CashHelper.getUser() ?? null;

    _userModel = user;
    notifyListeners();
  }

  String? getDrawerTitle() =>
      _userModel == null ? "SIGN IN" : _userModel?.displayName.toString();

  String? getDrawerSubTitle() => _userModel == null
      ? "Synchronization disabled"
      : "Synchronization enabled";
}
