import 'dart:convert';
import 'package:bancamovil/core/models/credits_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreditsService {
  Future<CreditsResponse?> getCredits() async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
    };
    var uri = Uri.parse('$baseUrl$socioCreditosEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        CreditsResponse respCredits = CreditsResponse.fromJson(data);
        print('Status Creditos: ${respCredits.status}');
        print('Mensaje Creditos: ${respCredits.message}');
        print('total Creditos: ${respCredits.data.length}');
        return respCredits;
      }
    } catch (e) {
      throw Exception('Error CreditsService: ${e.toString()}');
    }
    return null;
  }
}
