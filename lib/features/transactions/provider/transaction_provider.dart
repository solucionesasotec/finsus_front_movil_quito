// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/interbank_transaction_response.dart';
import 'package:bancamovil/core/models/internal_transaction_response.dart';
import 'package:bancamovil/core/models/sms_response.dart';
import 'package:bancamovil/core/models/sms_valid_response.dart';
import 'package:bancamovil/core/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionsService _transferService = TransactionsService();
  bool _isLoading = false;
  bool _isValidated = false;
  bool _isConfirmed = false;
  bool _isInternalComplete = false;
  bool _isInterbankComplete = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isValidated => _isValidated;
  bool get isConfirmed => _isConfirmed;
  bool get isInternalComplete => _isInternalComplete;
  bool get isInterbankComplete => _isInterbankComplete;
  String? get errorMessage => _errorMessage;

  Future<void> sendSms() async {
    _isLoading = true;
    notifyListeners();

    try {
      SmsResponse? accountsResp = await _transferService.sendSms();
      if (accountsResp != null) {
        if (accountsResp.status == 1) {
          _isValidated = true;
        } else {
          switch (accountsResp.message) {
            // case 'NO_RESULT':
            //   _errorMessage = 'No tiene cuentas';
            //   break;
            default:
              _errorMessage = 'Error desconocido: ${accountsResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error sms send provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> validateSms(String codigo) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Obtieen de memoria el token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      SmsValidResponse? validSmsResp =
          await _transferService.validateSms(token, codigo);
      if (validSmsResp != null) {
        if (validSmsResp.status == 1) {
          _isConfirmed = true;
        } else {
          switch (validSmsResp.message) {
            // case 'NO_RESULT':
            //   _errorMessage = 'No tiene cuentas';
            //   break;
            default:
              _errorMessage = 'Error desconocido: ${validSmsResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error sms validate provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Internal Transaction
  Future<void> internalTransaction(String producto, String cuenta, String monto,
      String productoSocio, String cuentaSocio, String descripcion) async {
    _isLoading = true;
    notifyListeners();

    try {
      InternalTransactionResponse? internalTransacResp =
          await _transferService.internalTransaction(
              producto, cuenta, monto, productoSocio, cuentaSocio, descripcion);

      if (internalTransacResp != null) {
        if (internalTransacResp.status == 1) {
          // print('Resp Provider TransfInter: ${internalTransacResp.status}');
          // print('Resp Provider TransfInter: ${internalTransacResp.message}');
          // print('Resp Provider TransfInter: ${internalTransacResp.data}');
          _isInternalComplete = true;
        } else {
          _errorMessage = internalTransacResp.message;
          // switch (internalTransacResp.message) {
          //   case 'NO_RESULT':
          //     _errorMessage = 'Mensaje';
          //     break;
          //   default:
          //     _errorMessage =
          //         'Error desconocido: ${internalTransacResp.message}';
          // }
        }
      }
    } catch (e) {
      print("Error internalTransaction provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Interbank Transaction
  Future<void> interbankTransaction(
      String producto,
      String cuenta,
      String monto,
      String banco,
      String identificacion,
      String beneficiario,
      String tipocuenta,
      String descripcion,
      String spiconcepto,
      String ctaacreditar,
      String tipocuentaacreditar) async {
    _isLoading = true;
    notifyListeners();

    try {
      InterbankTransactionResponse? interbankTransacResp =
          await _transferService.interbankTransaction(
              producto,
              cuenta,
              monto,
              banco,
              identificacion,
              beneficiario,
              tipocuenta,
              descripcion,
              spiconcepto,
              ctaacreditar,
              tipocuentaacreditar);

      if (interbankTransacResp != null) {
        if (interbankTransacResp.status == 1) {
          _isInterbankComplete = true;
          print("Transaccion interbancaria completada correctamente");

        } else {
          switch (interbankTransacResp.message) {
            // case 'NO_RESULT':
            //   _errorMessage = 'Mensaje';
            //   break;
            default:
              _errorMessage = '${interbankTransacResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error interbankTransaction provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
