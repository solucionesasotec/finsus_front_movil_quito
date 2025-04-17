class InternalTransactionResponse {

  final int status;
  final String message;
  final int? data;

  InternalTransactionResponse({required this.status, required this.message, required this.data});

  factory InternalTransactionResponse.fromJson(Map<String, dynamic> json) {
    return InternalTransactionResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}