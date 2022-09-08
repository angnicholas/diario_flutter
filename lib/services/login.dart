import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

//Login interface => defines the interface of the class.
String requestAccessTokenName = 'access';
String requestRefreshTokenName = 'refresh';
String requestIdName = 'id';

String localAccessTokenName = 'ACCESSTOKEN';
String localRefreshTokenName = 'REFRESHTOKEN';
String localUsernameName = 'USERNAME';
String localIdName = 'ID';

abstract class ILogin {
  //Function to send a login request to the backend.
  Future<UserModel?> login(String username, String password) async {
    final api = 'https://localhost:8000/auth/jwt/login';
    final data = {"username": username, "password": password};
    final dio = Dio();
    Response response;
    response = await dio.post(api, data: data);
    if (response.statusCode == 200) {
      final body = response.data;

      print(json.decode(response.data));

      return UserModel(
          username: username,
          accessToken: body[requestAccessTokenName],
          refreshToken: body[requestRefreshTokenName],
          id: body[requestIdName]);
    } else {
      return null;
    }
  }

  Future<UserModel?> getUser() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final username = storage.getString(localUsernameName);
    final accessToken = storage.getString(localAccessTokenName);
    final refreshToken = storage.getString(localRefreshTokenName);
    final id = storage.getInt(localIdName);

    if (accessToken != null &&
        username != null &&
        refreshToken != null &&
        id != null) {
      return UserModel(
        username: username,
        accessToken: accessToken,
        refreshToken: refreshToken,
        id: id,
      );
    } else {
      return null;
    }
  }

  Future<bool> logout() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return true;
  }
}

//Implements our interface.
class LoginService extends ILogin {
  @override
  Future<UserModel?> login(String username, String password) async {
    final api = Uri.parse('http://10.0.2.2:8000/auth/jwt/login');
    // final api = Uri.https('localhost:8000', 'auth/jwt/login');
    final data = {"username": username, "password": password};
    // final dio = Dio();
    http.Response response;
    response = await http.post(api, body: data);

    if (response.statusCode == 200) {
      SharedPreferences storage = await SharedPreferences.getInstance();
      final body = json.decode(response.body);

      await storage.setString(
          localAccessTokenName, body[requestAccessTokenName]);
      await storage.setString(
          localRefreshTokenName, body[requestRefreshTokenName]);
      await storage.setString(localUsernameName, username);
      await storage.setInt(localIdName, body[requestIdName]);

      return UserModel(
          username: username,
          accessToken: body[requestAccessTokenName],
          refreshToken: body[requestRefreshTokenName],
          id: body[requestIdName]);
    } else {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final username = storage.getString(localUsernameName);
    final token = storage.getString(localAccessTokenName);
    if (username != null && token != null) {
      await storage.remove(localAccessTokenName);
      await storage.remove(localRefreshTokenName);
      await storage.remove(localUsernameName);
      await storage.remove(localIdName);
      return true;
    } else {
      return false;
    }
  }
}
