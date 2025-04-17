import 'package:bancamovil/core/models/change_password_response.dart';
import 'package:bancamovil/core/services/change_password_service.dart';
import 'package:flutter/material.dart';

class RecoverPasswordProvider with ChangeNotifier {
  final ChangePasswordService _changePasswordService = ChangePasswordService();

  bool _isLoading = false;
  String? _errorMessage;
  late String? nomSocio;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> changePassword(String numCedula) async {
    _isLoading = true;
    notifyListeners();

    try {
      ChangePasswordResponse? changePasswordResponse =
          await _changePasswordService.changePassword(numCedula);

      if (changePasswordResponse != null) {
        if (changePasswordResponse.status == 1) {
          _errorMessage = null;
          nomSocio = changePasswordResponse.data.nomSocio;
          print('Nombre Socio: $nomSocio');
        } else {
          switch (changePasswordResponse.data) {
            case 'NO_RESULT':
              _errorMessage = 'No hay un socio con ese número de cédula.';
              break;
            default:
              _errorMessage =
                  'Error desconocido: ${changePasswordResponse.message}';
          }
        }
      }
    } catch (e) {
      print("Error change password provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
