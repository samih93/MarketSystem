class UserModel {
  String? displayName;
  String? email;
  String? photoURL;
  String? token;

  UserModel({this.displayName, this.email, this.photoURL, this.token});

  UserModel.fromJson(Map<String, dynamic> map) {
    displayName = map['displayName'];
    email = map['email'];
    photoURL = map['photoURL'];
    token = map['token'];
  }

  toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'token': token
    };
  }
}
