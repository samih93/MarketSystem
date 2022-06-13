import 'dart:convert';

import 'package:marketsystem/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static SharedPreferences? sharedPreferences;

  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future setTheme({required String key, required dynamic value}) async {
    await sharedPreferences!.setBool(key, value);
  }

  static bool? getThem({required String key}) {
    return sharedPreferences!.getBool(key);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> removeDatabykey({required String key}) async {
    return await sharedPreferences!.remove(key);
  }

  static Future<bool> saveUser(UserModel user) async {
    return await sharedPreferences!
        .setString('user', jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final json = sharedPreferences!.getString('user') ?? '';
    return json != '' ? await UserModel.fromJson(jsonDecode(json)) : null;
  }
}
