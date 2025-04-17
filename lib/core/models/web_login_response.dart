// import 'package:bancamovil/features/login/models/user.dart';

import 'package:bancamovil/core/models/web_login.dart';

class WebLoginResponse {

  final int status;
  final String message;
  final WebLogin list;

  WebLoginResponse({required this.status, required this.message, required this.list});

  factory WebLoginResponse.fromJson(Map<String, dynamic> json) {
    return WebLoginResponse(
      status: json['status'],
      message: json['message'],
      list: WebLogin.fromJson(json['list'])
    );
  }
}