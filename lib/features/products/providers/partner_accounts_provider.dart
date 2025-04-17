// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/partner_account.dart';
import 'package:bancamovil/core/models/partner_accounts_response.dart';
import 'package:bancamovil/core/services/partner_accounts_service.dart';
import 'package:flutter/material.dart';

class PartnerAccountsProvider with ChangeNotifier {
  final PartnerAccountsService _accountsService = PartnerAccountsService();
  bool _isLoading = false;
  late List<PartnerAccount> _accounts = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<PartnerAccount> get accounts => _accounts;
  String? get errorMessage => _errorMessage;

  Future<void> getAccounts() async {
    _isLoading = true;
    notifyListeners();

    try {
      PartnerAccountResponse? accountsResp = await _accountsService.getAccounts();
      if (accountsResp != null) {
        if (accountsResp.status == 1) {
          // _accounts = accountsResp.data;
          _accounts = accountsResp.data.where((account) => account.id.codProducto != 2).toList();

        } else {
          switch (accountsResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No tiene cuentas';
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
