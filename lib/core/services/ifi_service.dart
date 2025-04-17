
import 'dart:convert';

import 'package:bancamovil/core/models/ifi_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class IfiService {
  Future<IfiResponse?> getIfis() async {
    var uri = Uri.parse('$baseUrl$ifiEndpoint');

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        IfiResponse respIfi = IfiResponse.fromJson(data);
        print('Status List Ifi: ${respIfi.status}');
        print('Status List Ifi: ${respIfi.message}');
        print('Status List Ifi: ${respIfi.data.length}');
        return respIfi;
      }
    } catch (e) {
      throw Exception('Error IfiService: ${e.toString()}');
    }
    return null;
  }
}