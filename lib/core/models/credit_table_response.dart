
import 'package:bancamovil/core/models/credit_table.dart';

class CreditTableResponse {

  final int status;
  final String message;
  final List<CreditTable> data;

  CreditTableResponse(
      {required this.status, required this.message, required this.data});

  factory CreditTableResponse.fromJson(Map<String, dynamic> json) {
    return CreditTableResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => CreditTable.fromJson(a)).toList(),
    );
  }
}
