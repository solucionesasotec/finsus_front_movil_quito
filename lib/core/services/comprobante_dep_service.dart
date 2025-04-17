
import 'dart:convert';
import 'package:bancamovil/core/models/comprobante_dep_responde.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ComprobanteDepService {
  Future<ComprobanteDepReponse?> sendEmailComprobante() async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      // 'productosocio': producto,
      // 'cuentasocio': cuenta,
    };
    var uri = Uri.parse('$baseUrl$comprobanteDepositoEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        ComprobanteDepReponse respCompDep = ComprobanteDepReponse.fromJson(data);
        print('Status ComprDep: ${respCompDep.status}');
        print('Status ComprDep: ${respCompDep.message}');
        print('Status ComprDep: ${respCompDep.data}');
        return respCompDep;
      }
    } catch (e) {
      throw Exception('Error ComprobDepService: ${e.toString()}');
    }
    return null;
  }
}