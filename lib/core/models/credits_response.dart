
import 'package:bancamovil/core/models/credit.dart';

class CreditsResponse {

  final int status;
  final String message;
  final List<Credit> data;

  CreditsResponse({required this.status, required this.message, required this.data});

  factory CreditsResponse.fromJson(Map<String, dynamic> json) {
    return CreditsResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => Credit.fromJson(a)).toList(),
    );
  }
}