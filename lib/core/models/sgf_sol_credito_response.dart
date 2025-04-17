import 'package:bancamovil/core/models/sgf_sol_credito.dart';

class SgfSolCreditoResponse {

  final int status;
  final String message;
  final SgfSolCredito? data;

  SgfSolCreditoResponse({required this.status, required this.message, required this.data});

  factory SgfSolCreditoResponse.fromJson(Map<String, dynamic> json) {
    return SgfSolCreditoResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? SgfSolCredito.fromJson(json['data']) : null
    );
  }
}