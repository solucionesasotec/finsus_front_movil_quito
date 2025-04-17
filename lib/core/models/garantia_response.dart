

import 'package:bancamovil/core/models/garantia.dart';

class GarantiaResponse {

  final int status;
  final String message;
  final List<Garantia> data;

  GarantiaResponse({required this.status, required this.message, required this.data});

  factory GarantiaResponse.fromJson(Map<String, dynamic> json) {
    return GarantiaResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => Garantia.fromJson(a)).toList(),
    );
  }
}