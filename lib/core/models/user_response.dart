// import 'package:bancamovil/features/login/models/user.dart';

import 'package:bancamovil/core/models/user.dart';

class UserResponse {

  final int status;
  final String message;
  // final String dataset;
  final User list;

  UserResponse({required this.status, required this.message, required this.list});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      message: json['message'],
      // list: json['list'],
      list: User.fromJson(json['list'])
    );
  }
}