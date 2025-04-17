
import 'package:bancamovil/core/models/type_credit.dart';

class TypeCreditResponse {

  final int status;
  final String message;
  final List<TypeCredit> data;

  TypeCreditResponse({required this.status, required this.message, required this.data});

  factory TypeCreditResponse.fromJson(Map<String, dynamic> json) {
    return TypeCreditResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => TypeCredit.fromJson(a)).toList(),
    );
  }
}