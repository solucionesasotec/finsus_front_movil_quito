class LoginResponse {

  final int status;
  final String message;
  // final String dataset;
  final String list;

  LoginResponse({required this.status, required this.message, required this.list});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      list: json['list'],
    );
  }
}