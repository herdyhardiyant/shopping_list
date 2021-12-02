import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dbcrypt/dbcrypt.dart';

class User with ChangeNotifier {
  var isAuthorized = false;
  static String userId = "default-user";

  Future<void> registerUser(String username, String password) async {
    try {
      var hashedPassword = DBCrypt().hashpw(password, DBCrypt().gensalt());
      final uri = Uri.parse(
          'https://shopping-list-f6c78-default-rtdb.asia-southeast1.firebasedatabase.app/user.json');
      bool isAlreadyExist = await checkIsUserExist(username);
      final response = await http.post(uri,
          body:
              json.encode({"username": username, "password": hashedPassword}));

      userId = json.decode(response.body)["name"];
      isAuthorized = true;
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> checkIsUserExist(String username) async {
    var usersData = await _userData;
    bool isExist = false;
    usersData.forEach((key, value) {
      if (value["username"] == username) {
        isExist = true;
      }
    });

    return isExist;
  }

  Future<bool> loginUser(String username, String password) async {
    try {
      var usersData = await _userData;
      usersData.forEach((key, value) {
        var isPasswordCorrect = DBCrypt().checkpw(password, value["password"]);
        if (value["username"] == username && isPasswordCorrect) {
          isAuthorized = true;

          userId = key;
          notifyListeners();
        }
      });
      return isAuthorized;
    } catch (_) {
      return isAuthorized;
    }
  }

  Future<Map<String, dynamic>> get _userData async {
    final uri = Uri.parse(
        'https://shopping-list-f6c78-default-rtdb.asia-southeast1.firebasedatabase.app/user.json');
    final response = await http.get(uri);
    Map<String, dynamic> usersData = json.decode(response.body);
    return usersData;
  }

  Future<void> logoutUser() async {
    isAuthorized = false;
    notifyListeners();
  }
}
