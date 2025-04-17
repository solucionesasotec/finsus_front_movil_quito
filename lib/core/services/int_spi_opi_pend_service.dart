import 'dart:convert';
import 'package:bancamovil/core/models/int_spi_opi_pend_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IntSpiOpiPendService {
  Future<IntSpiOpiPendResponse?> createDeposite(
      String productoenvia,
      String cuentaenvia,
      String producto,
      String cuenta,
      String banco,
      String monto,
      String comprobante
      ) async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      'productoenvia': productoenvia,
      'cuentaenvia': cuentaenvia,
      'producto': producto,
      'cuenta': cuenta,
      'banco': banco,
      'monto': monto,
      // 'comprobante': comprobante,
    };

    var body = {
      'comprobante': comprobante, // imagen en base64
    };
    var bodyJson = json.encode(body);

    var uri = Uri.parse('$baseUrl$intSpiOpiPendDepositoEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: bodyJson,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        IntSpiOpiPendResponse respDeposito =
            IntSpiOpiPendResponse.fromJson(data);
        print('Status Spi Deposito: ${respDeposito.status}');
        print('Status Spi Deposito: ${respDeposito.message}');
        print('Status Spi Deposito: ${respDeposito.data}');
        return respDeposito;
      }
    } catch (e) {
      throw Exception('Error SpiDepositoService: ${e.toString()}');
    }
    return null;
  }
}
