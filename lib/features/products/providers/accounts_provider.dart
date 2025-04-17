// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/account.dart';
import 'package:bancamovil/core/models/account_response.dart';
import 'package:bancamovil/core/services/accounts_service.dart';
import 'package:flutter/material.dart';

class AccountsProvider with ChangeNotifier {
  final AccountService _accountService = AccountService();
  bool _isLoading = false;
  late List<Account> _accounts = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Account> get accounts => _accounts;
  String? get errorMessage => _errorMessage;

  Future<void> getAccount(String producto, String cuenta) async {
    _isLoading = true;
    notifyListeners();

    try {
      AccountResponse? accountsResp = await _accountService.getAccount(producto, cuenta);
      if (accountsResp != null) {
        if (accountsResp.status == 1) {
          _accounts = accountsResp.data;

        } else {
          switch (accountsResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No tiene cuentas con el producto $producto nro $cuenta';
              break;
            default:
              _errorMessage = 'Error desconocido: ${accountsResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error accounts provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
      _accounts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

}
