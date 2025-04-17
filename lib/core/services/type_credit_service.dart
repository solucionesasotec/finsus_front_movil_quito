import 'dart:convert';
import 'package:bancamovil/core/models/type_credit_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class TypeCreditService {
  Future<TypeCreditResponse?> getTypeCredits() async {
    
    var uri = Uri.parse('$baseUrl$tipoCreditoEndpoint');
    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        TypeCreditResponse respTypeCredits = TypeCreditResponse.fromJson(data);
        print('Status Tipo Creditos: ${respTypeCredits.status}');
        print('Status Tipo Creditos: ${respTypeCredits.message}');
        print('Status Tipo Creditos: ${respTypeCredits.data.length}');
        return respTypeCredits;
      }
    } catch (e) {
      throw Exception('Error TypeCreditsService: ${e.toString()}');
    }
    return null;
  }
}
