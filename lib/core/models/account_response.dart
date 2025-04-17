
import 'package:bancamovil/core/models/account.dart';

class AccountResponse {

  final int status;
  final String message;
  final List<Account> data;

  AccountResponse({required this.status, required this.message, required this.data});

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => Account.fromJson(a)).toList(),
    );
  }
}