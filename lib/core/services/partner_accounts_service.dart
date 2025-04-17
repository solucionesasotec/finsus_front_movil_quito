import 'dart:convert';
import 'package:bancamovil/core/models/partner_accounts_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PartnerAccountsService {
  Future<PartnerAccountResponse?> getAccounts() async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
    };
    var uri = Uri.parse('$baseUrl$socioCuentasEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        PartnerAccountResponse respAccounts = PartnerAccountResponse.fromJson(data);
        // print('Status SocioCuentas: ${respAccounts.status}');
        // print('Status SocioCuentas: ${respAccounts.message}');
        // print('Status SocioCuentas: ${respAccounts.data.length}');
        return respAccounts;
      }
    } catch (e) {
      throw Exception('Error PartnerAccountService: ${e.toString()}');
    }
    return null;
  }
}
