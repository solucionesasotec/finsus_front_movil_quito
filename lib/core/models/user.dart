class User {
  final int codSocio;
  final String? codTipoSocio;
  final String? codTipoId;
  final String? numId;
  final String? nomSocio;
  final String? apeSocio;
  final String? dirCorreo;
  final String? telCelular;
  final String? dirDom;
  final String? stsCivil;

  

  User({
    required this.codSocio,
    required this.codTipoSocio,
    required this.codTipoId,
    required this.numId,
    required this.nomSocio,
    required this.apeSocio,
    required this.dirCorreo,
    required this.telCelular,
    required this.dirDom,
    required this.stsCivil,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      codSocio: json['codSocio'],
      codTipoSocio: json['codTipoSocio'],
      codTipoId: json['codTipoId'],
      numId: json['numId'],
      nomSocio: json['nomSocio'],
      apeSocio: json['apeSocio'],
      dirCorreo: json['dirCorreo'],
      telCelular: json['telCelular'],
      dirDom: json['dirDom'],
      stsCivil: json['stsCivil'],
    );
  }

  // Convertir de User a JSON
  Map<String, dynamic> toJson() {
    return {
      'codSocio': codSocio,
      'codTipoSocio': codTipoSocio,
      'nomSocio': nomSocio,
      'apeSocio': apeSocio,
      'dirCorreo': dirCorreo,
      'telCelular': telCelular,
      'dirDom': dirDom,
    };
  }
}
