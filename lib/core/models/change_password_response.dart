class ChangePasswordResponse {
  final int status;
  final String message;
  final dynamic data;

  ChangePasswordResponse(
      {required this.status, required this.message, required this.data});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] is Map
          ? ChangePasswordData.fromJson(json['data'])
          : json['data'],
    );
  }
}

class ChangePasswordData {
  final String nomSocio;

  ChangePasswordData({
    required this.nomSocio,
  });

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) {
    return ChangePasswordData(
      nomSocio: json['nomSocio'],
    );
  }
}
