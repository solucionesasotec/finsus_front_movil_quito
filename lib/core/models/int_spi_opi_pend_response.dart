
import 'package:bancamovil/core/models/int_spi_opi_pend.dart';

class IntSpiOpiPendResponse {

  final int status;
  final String message;
  final IntSpiOpiPend data;

  IntSpiOpiPendResponse({required this.status, required this.message, required this.data});

  factory IntSpiOpiPendResponse.fromJson(Map<String, dynamic> json) {
    return IntSpiOpiPendResponse(
      status: json['status'],
      message: json['message'],
      data: IntSpiOpiPend.fromJson(json['data']),
    );
  }
}