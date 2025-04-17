import 'dart:convert';
import 'package:bancamovil/core/models/clasif_credit_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class ClasifCreditService {
  Future<ClasifCreditResponse?> getClasifCredits() async {
    
    var uri = Uri.parse('$baseUrl$clasifCreditoEndpoint');
    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        ClasifCreditResponse respClasifCredits = ClasifCreditResponse.fromJson(data);
        // print('Status Clasif Credito: ${respClasifCredits.status}');
        // print('Status Clasif Credito: ${respClasifCredits.message}');
        // print('Status Clasif Credito: ${respClasifCredits.data.length}');
        return respClasifCredits;
      }
    } catch (e) {
      throw Exception('Error ClasifCreditsService: ${e.toString()}');
    }
    return null;
  }
}
