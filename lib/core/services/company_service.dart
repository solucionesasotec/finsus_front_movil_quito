import 'dart:convert';
import 'package:bancamovil/core/models/company_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  Future<CompanyResponse?> getEmpresa(String empresa) async {
    
    var queryParams = {
      'empresa': empresa,
    };
    var uri = Uri.parse('$baseUrl$empresaEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        CompanyResponse respCompany = CompanyResponse.fromJson(data);
        print('Status Empresa: ${respCompany.status}');
        print('Status Empresa: ${respCompany.message}');
        print('Status Empresa: ${respCompany.list}');
        return respCompany;
      }
    } catch (e) {
      throw Exception('Error CompanyService: ${e.toString()}');
    }
    return null;
  }
}
