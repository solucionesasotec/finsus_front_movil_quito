import 'dart:convert';
import 'package:bancamovil/core/models/movements_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovementsService {
  Future<MovementsResponse?> getMovements(
      String desde, String hasta, String producto, String cuenta) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      'desde': desde,
      'hasta': hasta,
      'producto': producto,
      'cuenta': cuenta,
    };
    var uri = Uri.parse('$baseUrl$socioCuentaDetallesEndpoint')
        .replace(queryParameters: queryParams);
    var response = await http.post(uri);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      MovementsResponse respMovements = MovementsResponse.fromJson(data);

      // print('Service-Movements-status: ${desde}');
      // print('Service-Movements-status: ${hasta}');
      // print('Service-Movements-status: ${respMovements.status}');
      // print('Service-Movements-message: ${respMovements.message}');
      // print('Service-Movements-data: ${respMovements.data.length}');
      return respMovements;
    }
    return null;
  }
}
