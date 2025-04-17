import 'package:bancamovil/core/models/bank_account.dart';
import 'package:bancamovil/core/models/bank_account_response.dart';
import 'package:bancamovil/core/services/bank_account_service.dart';
import 'package:flutter/material.dart';

class BankAccountProvider with ChangeNotifier {
  final BankAccountService _bankAccountService = BankAccountService();

  bool _isLoading = false;
  late List<BankAccount> _bankAccount = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<BankAccount> get cuentasBanco => _bankAccount;
  String? get errorMessage => _errorMessage;

  Future<void> getBankAccounts() async {
    print("Ejecutando getBankAccounts..."); // <-- Debugging
    _isLoading = true;
    notifyListeners();

    try {
      BankAccountResponse? bankAccountResp =
          await _bankAccountService.getBankAccounts();
      if (bankAccountResp != null) {
        if (bankAccountResp.status == 1) {
          _bankAccount = bankAccountResp.data;
          print("Respuesta recibida de getBankAccounts");
        } else {
          switch (bankAccountResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No tiene cuentas de banco';
              break;
            default:
              _errorMessage = 'Error desconocido (provider): ${bankAccountResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error cuentas de banco provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo. (Provider)';
      _bankAccount = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
