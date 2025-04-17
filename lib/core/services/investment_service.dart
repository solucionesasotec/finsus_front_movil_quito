
import 'dart:convert';

import 'package:bancamovil/core/models/investments_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InvestmentService {
  Future<InvestmentResponse?> getInvestments() async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
    };
    var uri = Uri.parse('$baseUrl$socioInversionesEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        InvestmentResponse respInvestments = InvestmentResponse.fromJson(data);
        print('Status Creditos: ${respInvestments.status}');
        print('Status Creditos: ${respInvestments.message}');
        print('Status Creditos: ${respInvestments.data.length}');
        return respInvestments;
      }
    } catch (e) {
      throw Exception('Error InvestmentsService: ${e.toString()}');
    }
    return null;
  }
}