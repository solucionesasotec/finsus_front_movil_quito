import 'dart:convert';
import 'package:bancamovil/core/models/account_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  Future<AccountResponse?> getAccount(String producto, String cuenta) async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      'productosocio': producto,
      'cuentasocio': cuenta,
    };
    var uri = Uri.parse('$baseUrl$socioCuentaEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        AccountResponse respAccounts = AccountResponse.fromJson(data);
        print('Status Cuentas: ${respAccounts.status}');
        print('Status Cuentas: ${respAccounts.message}');
        print('Status Cuentas: ${respAccounts.data.length}');
        return respAccounts;
      }
    } catch (e) {
      throw Exception('Error AccountService: ${e.toString()}');
    }
    return null;
  }
}
