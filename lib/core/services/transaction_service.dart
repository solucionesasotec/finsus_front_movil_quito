// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bancamovil/core/models/interbank_transaction_response.dart';
import 'package:bancamovil/core/models/internal_transaction_response.dart';
import 'package:bancamovil/core/models/sms_response.dart';
import 'package:bancamovil/core/models/sms_valid_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsService {
  // Envio Correo y SMS con codigo de verificacion
  Future<SmsResponse?> sendSms() async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
    };
    var uri = Uri.parse('$baseUrl$sendSmsEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        SmsResponse userResp = SmsResponse.fromJson(data);
        print('Service-SendSms-status: ${userResp.status}');
        print('Service-SendSms-message: ${userResp.message}');
        print('Service-SendSms-data: ${userResp.data}');
        return userResp;
      }
    } catch (e) {
      throw Exception('Error sendSms Service: ${e.toString()}');
    }
    return null;
  }

  // Valida SMS con el còdigo de verificación
  Future<SmsValidResponse?> validateSms(String? token, String clave) async {
    var queryParams = {
      'token': token,
      'clave': clave,
    };
    var uri = Uri.parse('$baseUrl$validateSmsEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        SmsValidResponse smsValidResp = SmsValidResponse.fromJson(data);
        print('Service-ValidCodeSms-status: ${smsValidResp.status}');
        print('Service-ValidCodeSms-message: ${smsValidResp.message}');
        print('Service-ValidCodeSms-dataset: ${smsValidResp.dataset}');
        print('Service-ValidCodeSms-data: ${smsValidResp.list}');
        return smsValidResp;
      }
    } catch (e) {
      throw Exception('Error validateSms Service: ${e.toString()}');
    }
    return null;
  }

  // Transaccion interna
  Future<InternalTransactionResponse?> internalTransaction(
      String producto,
      String cuenta,
      String monto,
      String productoSocio,
      String cuentaSocio,
      String descripcion) async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      'producto': producto,
      'cuenta': cuenta,
      'monto': monto,
      'productosocio': productoSocio,
      'cuentasocio': cuentaSocio,
      'descripcion': descripcion,
    };
    var uri = Uri.parse('$baseUrl$internalTransactionEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        InternalTransactionResponse internalTransfResp =
            InternalTransactionResponse.fromJson(data);
        print('Service-InternalTranf-status: ${internalTransfResp.status}');
        print('Service-InternalTranf-message: ${internalTransfResp.message}');
        print('Service-InternalTranf-data: ${internalTransfResp.data}');
        return internalTransfResp;
      }
    } catch (e) {
      throw Exception('Error internalTransaction Service: ${e.toString()}');
    }
    return null;
  }

  // Interbank transaction
  Future<InterbankTransactionResponse?> interbankTransaction(
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
    // Obtiene de memoria
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
      'producto': producto,
      'cuenta': cuenta,
      'monto': monto,
      'banco': banco,
      'identificacion': identificacion,
      'beneficiario': beneficiario,
      'tipocuenta': tipocuenta,
      'descripcion': descripcion,
      'spiconcepto': spiconcepto,
      'ctaacreditar': ctaacreditar,
      'tipocuentaacreditar': tipocuentaacreditar
    };
    var uri = Uri.parse('$baseUrl$spiTransactionEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        InterbankTransactionResponse interbankTransfResp = InterbankTransactionResponse.fromJson(data);
        print('Service-InterbankTranf-status: ${interbankTransfResp.status}');
        print('Service-InterbankTranf-message: ${interbankTransfResp.message}');
        print('Service-InterbankTranf-data: ${interbankTransfResp.data}');
        return interbankTransfResp;
      }
    } catch (e) {
      throw Exception('Error interbankTransaction Service: ${e.toString()}');
    }
    return null;
  }
}
