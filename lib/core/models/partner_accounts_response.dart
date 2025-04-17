

import 'package:bancamovil/core/models/partner_account.dart';

class PartnerAccountResponse {

  final int status;
  final String message;
  final List<PartnerAccount> data;

  PartnerAccountResponse({required this.status, required this.message, required this.data});

  factory PartnerAccountResponse.fromJson(Map<String, dynamic> json) {
    return PartnerAccountResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => PartnerAccount.fromJson(a)).toList(),
    );
  }
}