// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/web_login.dart';
import 'package:bancamovil/core/models/web_login_response.dart';
import 'package:bancamovil/core/services/web_login_service.dart';
import 'package:flutter/material.dart';

class WebLoginProvider with ChangeNotifier {
  final WebLoginService _webLoginService = WebLoginService();
  bool _isLoading = false;
  late WebLogin _webLogin;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  WebLogin get webLogin => _webLogin;
  String? get errorMessage => _errorMessage;

  Future<void> updatePassword(String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      WebLoginResponse? accountsResp = await _webLoginService.updatePassword(newPassword);
      if (accountsResp != null) {
        if (accountsResp.status == 1) {
          _webLogin = accountsResp.list;

        } else {
          switch (accountsResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No es nuevo socio';
              break;
            default:
              _errorMessage = 'Error desconocido: ${accountsResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error accounts provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }

}
