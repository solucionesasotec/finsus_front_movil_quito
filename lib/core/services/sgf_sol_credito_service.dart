import 'dart:convert';
import 'package:bancamovil/core/models/sgf_sol_credito_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SgfSolCreditoService {
  Future<SgfSolCreditoResponse?> generateSolCredit(
    String cuenta,
    String capital,
    String tasa,
    String valinteres,
    String cuotas,
    String fechaprestamo,
    String fechavencimiento,
    String plazo,
    String fecvencimiento,
    String tipocredito,
    String clasifcredito,
  ) async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      'cuenta': cuenta,
      'capital': capital,
      'tasa': tasa,
      'valinteres': valinteres,
      'cuotas': cuotas,
      'fechaprestamo': fechaprestamo,
      'fechavencimiento': fechavencimiento,
      'plazo': plazo,
      'fecvencimiento': fecvencimiento,
      'tipocredito': tipocredito,
      'clasifcredito': clasifcredito,
    };
    var uri = Uri.parse('$baseUrl$solCreditoEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        SgfSolCreditoResponse solCredit = SgfSolCreditoResponse.fromJson(data);
        print('Status SolCredito Service: ${solCredit.status}');
        print('Status SolCredito Service: ${solCredit.message}');
        print('Status SolCredito Service: ${solCredit.data}');
        return solCredit;
      }
    } catch (e) {
      throw Exception('Error SolCredit Service: ${e.toString()}');
    }
    return null;
  }
}
