class WebLogin {
  final int codSocio;
  final String webClave;
  final String stsClaveCreada;
  final String stsLogin;
  final int webIntentos;
  final String webToken;
  final String stsWebToken;

  WebLogin({
    required this.codSocio,
    required this.webClave,
    required this.stsClaveCreada,
    required this.stsLogin,
    required this.webIntentos,
    required this.webToken,
    required this.stsWebToken,
  });

  factory WebLogin.fromJson(Map<String, dynamic> json) {
    return WebLogin(
      codSocio: json['codSocio'],
      webClave: json['webClave'],
      stsClaveCreada: json['stsClaveCreada'],
      stsLogin: json['stsLogin'],
      webIntentos: json['webIntentos'],
      webToken: json['webToken'],
      stsWebToken: json['stsWebToken'],
    );
  }
}
