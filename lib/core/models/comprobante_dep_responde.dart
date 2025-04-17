class ComprobanteDepReponse {

  final int status;
  final String message;
  final String? data;

  ComprobanteDepReponse({required this.status, required this.message, required this.data});

  factory ComprobanteDepReponse.fromJson(Map<String, dynamic> json) {
    return ComprobanteDepReponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}