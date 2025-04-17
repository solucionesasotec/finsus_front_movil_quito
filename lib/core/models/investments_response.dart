import 'package:bancamovil/core/models/investments.dart';

class InvestmentResponse {

  final int status;
  final String message;
  final List<Investment> data;

  InvestmentResponse({required this.status, required this.message, required this.data});

  factory InvestmentResponse.fromJson(Map<String, dynamic> json) {
    return InvestmentResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => Investment.fromJson(a)).toList(),
    );
  }
}