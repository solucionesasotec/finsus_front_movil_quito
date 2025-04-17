

import 'dart:convert';

import 'package:bancamovil/core/models/garantia_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GarantiaService {
  Future<GarantiaResponse?> getGarantias() async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
    };
    var uri = Uri.parse('$baseUrl$garantiasEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        GarantiaResponse respIfi = GarantiaResponse.fromJson(data);
        // print('Status List Garantia: ${respIfi.status}');
        // print('Status List Garantia: ${respIfi.message}');
        // print('Status List Garantia: ${respIfi.data.length}');
        return respIfi;
      }
    } catch (e) {
      throw Exception('Error GarantiaService: ${e.toString()}');
    }
    return null;
  }
}