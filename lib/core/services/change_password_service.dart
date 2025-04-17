import 'dart:convert';
import 'package:bancamovil/core/models/change_password_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  Future<ChangePasswordResponse?> changePassword(String numCedula) async {
    var queryParams = {
      'numCedula': numCedula,
    };

    var uri = Uri.parse('$baseUrl$changePasswordEndpoint')
        .replace(queryParameters: queryParams);

    print('URI Change Password: $uri');

    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        ChangePasswordResponse respChangePass =
            ChangePasswordResponse.fromJson(data);
        print('Status Change Password: ${respChangePass.status}');
        print('Message Change Password: ${respChangePass.message}');
        print('Data Change Password: ${respChangePass.data.toString()}');
        return respChangePass;
      }
    } catch (e) {
      throw Exception('Error ChangePasswordService: ${e.toString()}');
    }
    return null;
  }
}
