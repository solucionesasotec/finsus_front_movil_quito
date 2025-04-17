

class SmsResponse {

  final int status;
  final String message;
  final String data;

  SmsResponse({required this.status, required this.message, required this.data});

  factory SmsResponse.fromJson(Map<String, dynamic> json) {
    return SmsResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}