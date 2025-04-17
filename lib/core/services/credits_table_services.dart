import 'dart:convert';
import 'package:bancamovil/core/models/credit_table_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreditTableService {
  Future<CreditTableResponse?> getCreditTable(String producto, String cuenta) async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      'producto': producto,
      'cuenta': cuenta,
    };
    var uri = Uri.parse('$baseUrl$socioCreditoTablaEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        CreditTableResponse respCreditTable = CreditTableResponse.fromJson(data);
        print('Status CreditoTabla: ${respCreditTable.status}');
        print('Status CreditoTabla: ${respCreditTable.message}');
        print('Status CreditoTabla: ${respCreditTable.data.length}');
        return respCreditTable;
      }
    } catch (e) {
      throw Exception('Error CreditTableService: ${e.toString()}');
    }
    return null;
  }
}
