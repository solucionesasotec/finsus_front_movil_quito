import 'package:bancamovil/core/models/bank_account.dart';

class BankAccountResponse {
  final int status;
  final String message;
  final List<BankAccount> data;

  BankAccountResponse(
      {required this.status, required this.message, required this.data});

  factory BankAccountResponse.fromJson(Map<String, dynamic> json) {
    return BankAccountResponse(
        status: json['status'] ?? '0', 
        message: json['message'] ?? 'error', 
        data: (json['data'] as List).map((a) => BankAccount.fromJson(a)).toList());
  }
}
