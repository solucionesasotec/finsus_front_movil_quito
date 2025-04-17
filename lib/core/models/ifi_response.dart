
import 'package:bancamovil/core/models/ifi.dart';

class IfiResponse {

  final int status;
  final String message;
  final List<Ifi> data;

  IfiResponse({required this.status, required this.message, required this.data});

  factory IfiResponse.fromJson(Map<String, dynamic> json) {
    return IfiResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => Ifi.fromJson(a)).toList(),
    );
  }
}