

import 'package:bancamovil/core/models/clasif_credit.dart';

class ClasifCreditResponse {

  final int status;
  final String message;
  final List<ClasifCredit> data;

  ClasifCreditResponse({required this.status, required this.message, required this.data});

  factory ClasifCreditResponse.fromJson(Map<String, dynamic> json) {
    return ClasifCreditResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => ClasifCredit.fromJson(a)).toList(),
    );
  }
}