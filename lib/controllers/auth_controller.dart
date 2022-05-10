import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketsystem/models/user.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/local/cash_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class AuthController extends ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

//NOTE Sign with google --------------------
  String statusLoginMessage = "";
  ToastStatus toastLoginStatus = ToastStatus.Error;
  bool isloadingLogin = false;
  UserModel? _userModel = null;
  // UserModel? get userModel => _userModel;

  Future<void> signInWithGoogle() async {
    UserCredential? _user = null;
    GoogleSignInAccount? googleUser;

    // Trigger the authentication flow

    try {
      googleUser = await GoogleSignIn().signIn();
      isloadingLogin = true;
      statusLoginMessage = "You have been successfully logged In ";
      toastLoginStatus = ToastStatus.Success;
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

// NOTE constant
          currentuser = _userModel;

          CashHelper.saveUser(_userModel!);
          isloadingLogin = false;
          notifyListeners();
        });
    } catch (e) {
      statusLoginMessage =
          "Logged In failed, check your network connection and try again";
      toastLoginStatus = ToastStatus.Error;
      isloadingLogin = false;
      notifyListeners();
    }
  }
// NOTE google Sign Out ----------------------

  String statusSignOutMessage = "";
  ToastStatus toastSignOutStatus = ToastStatus.Error;
  bool isloadingSignOut = false;
  Future<void> google_signOut() async {
    isloadingSignOut = true;
    notifyListeners();
    await _googleSignIn.signOut().then((value) {
      statusLoginMessage = "You have been successfully logged out";
      toastSignOutStatus = ToastStatus.Success;
      _userModel = null;
      currentuser = null;
      CashHelper.removeDatabykey(key: "user");
      isloadingSignOut = false;
      notifyListeners();
      // print(_user?.user?.displayName);
    }).catchError((error) {
      statusSignOutMessage =
          "Logged In failed, check your network connection and try again";
      toastSignOutStatus = ToastStatus.Error;
      isloadingSignOut = false;
      notifyListeners();
    });
  }

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
