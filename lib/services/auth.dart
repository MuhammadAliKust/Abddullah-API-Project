import 'dart:convert';

import 'package:abdullah_api/models/login.dart';
import 'package:abdullah_api/models/register.dart';
import 'package:abdullah_api/models/user.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  String baseUrl = "https://todo-nu-plum-19.vercel.app/";

  ///Register
  Future<RegisterModel> registerUser(
      {required String name, required String email, required password}) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}users/register"),
          headers: {'Content-Type': 'application/json'},
          body:
              jsonEncode({"name": name, "email": email, "password": password}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterModel.fromJson(jsonDecode(response.body));
      } else {
        return RegisterModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Login
  Future<LoginModel> loginUser(
      {required String email, required password}) async {
    try {
      http.Response response = await http.post(
          Uri.parse("${baseUrl}users/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"email": email, "password": password}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginModel.fromJson(jsonDecode(response.body));
      } else {
        return LoginModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Get Profile
  Future<UserModel> getProfile(String token) async {
    try {
      http.Response response = await http.get(
          Uri.parse("${baseUrl}users/profile"),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        return UserModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Update Profile
  Future<bool> updateProfile(
      {required String token, required String name}) async {
    try {
      http.Response response = await http.put(
          Uri.parse("${baseUrl}users/profile"),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: jsonEncode({'name': name}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
