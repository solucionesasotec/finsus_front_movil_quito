

import 'package:bancamovil/core/models/movement.dart';

class MovementsResponse {

  final int status;
  final String message;
  final List<Movement> data;

  MovementsResponse({required this.status, required this.message, required this.data});

  factory MovementsResponse.fromJson(Map<String, dynamic> json) {
    return MovementsResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => Movement.fromJson(a)).toList(),
    );
  }
}