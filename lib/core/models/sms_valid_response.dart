class SmsValidResponse {
  final int status;
  final String message;
  final String? dataset;
  final String list;

  SmsValidResponse(
      {required this.status,
      required this.message,
      required this.dataset,
      required this.list});

  factory SmsValidResponse.fromJson(Map<String, dynamic> json) {
    return SmsValidResponse(
      status: json['status'],
      message: json['message'],
      dataset: json['dataset'],
      list: json['list'],
    );
  }
}
