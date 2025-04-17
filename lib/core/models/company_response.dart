import 'package:bancamovil/core/models/company.dart';

class CompanyResponse {
  final int status;
  final String message;
  final String? dataset;
  final Company list;

  CompanyResponse({
    required this.status,
    required this.message,
    required this.dataset,
    required this.list,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      status: json['status'],
      message: json['message'],
      dataset: json['dataset'],
      list: Company.fromJson(json['list']),
    );
  }
}
