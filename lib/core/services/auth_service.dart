// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bancamovil/core/models/login_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<LoginResponse?> login(String username, String password) async {
    var queryParams = {
      'username': username,
      'password': password,
    };
    var uri = Uri.parse('$baseUrl$loginEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        LoginResponse session = LoginResponse.fromJson(data);
        print('Service-login-status: ${session.status}');
        print('Service-login-message: ${session.message}');
        print('Service-login-list: ${session.list}');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', session.list);
        
        return session;
      }
    } catch (e) {
      throw Exception('Error AuthService: ${e.toString()}');
    }
    return null;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
