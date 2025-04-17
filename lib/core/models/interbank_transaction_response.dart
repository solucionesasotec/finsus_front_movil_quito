import 'package:bancamovil/core/models/interbank_transaction_data.dart';

class InterbankTransactionResponse {

  final int? status;
  final String? message;
  final InterBankTransactionData? data;
  /*
  {
    "data": {
        "a_sts_retorno": 1,
        "li_cod_oficina": 1,
        "ls_cod_transaccion": "NDSPI",
        "ldo_num_transaccion": 100007
    },
    "message": "correcto",
    "status": 1
}
  */

  InterbankTransactionResponse({required this.status, required this.message, required this.data});

  factory InterbankTransactionResponse.fromJson(Map<String, dynamic> json) {
    return InterbankTransactionResponse(
      status: json['status'],
      message: json['message'],
      data: InterBankTransactionData.fromJson(json['data']),
    );
  }
}