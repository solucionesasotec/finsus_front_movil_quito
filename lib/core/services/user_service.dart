// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bancamovil/core/models/user_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<UserResponse?> getUser(String token) async {
    var queryParams = {
      'token': token,
    };
    var uri = Uri.parse('$baseUrl$socioEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        UserResponse userResp = UserResponse.fromJson(data);
        print('Service-User-status: ${userResp.status}');
        print('Service-User-message: ${userResp.message}');
        print('Service-User-list: ${userResp.list}');
        return userResp;
      }
    } catch (e) {
      throw Exception('Error UserService: ${e.toString()}');
    }
    return null;
  }
}
