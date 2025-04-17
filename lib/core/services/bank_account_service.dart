import 'dart:convert';
import 'package:bancamovil/core/models/bank_account_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class BankAccountService {
  Future<BankAccountResponse?> getBankAccounts() async {
    var uri = Uri.parse('$baseUrl$bankAccountEndpoint').replace();
    try {
      // var response = await http.post(uri);
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        BankAccountResponse respBankAccount =
            BankAccountResponse.fromJson(data);
        print('Status CuentaBanco: ${respBankAccount.status}');
        print('Mensaje CuentaBanco: ${respBankAccount.message}');
        print('total CuentaBanco: ${respBankAccount.data.length}');
        return respBankAccount;
      }
    } catch (e) {
      throw Exception('Error BankAccountService: ${e.toString()}');
    }
    return null;
  }
}