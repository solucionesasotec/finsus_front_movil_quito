// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bancamovil/core/models/web_login_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WebLoginService {
  Future<WebLoginResponse?> updatePassword(String newPassword) async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      'password': newPassword,
    };
    var uri = Uri.parse('$baseUrl$actualizaClaveEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        WebLoginResponse webLoginResp = WebLoginResponse.fromJson(data);
        print('Service WebLogin status: ${webLoginResp.status}');
        print('Service WebLogin message: ${webLoginResp.message}');
        print('Service WebLogin list: ${webLoginResp.list}');
        return webLoginResp;
      }
    } catch (e) {
      throw Exception('Error WebLogin Service: ${e.toString()}');
    }
    return null;
  }
}
