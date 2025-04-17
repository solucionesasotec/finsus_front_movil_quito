class Company {
  final int codEmpresa;
  final String nomEmpresa;
  final String nomAbreviado;
  final int numRuc;
  // Add fields

  Company({
    required this.codEmpresa,
    required this.nomEmpresa,
    required this.nomAbreviado,
    required this.numRuc,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      codEmpresa: json['codEmpresa'],
      nomEmpresa: json['nomEmpresa'],
      nomAbreviado: json['nomAbreviado'],
      numRuc: json['numRuc'],
    );
  }
}
