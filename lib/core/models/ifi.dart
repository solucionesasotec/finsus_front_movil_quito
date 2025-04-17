class Ifi {
  final int cod_cuenta_bce;
  final String nom_cuenta_bce;
  final String sts_cuenta_bce;

  Ifi({
    required this.cod_cuenta_bce,
    required this.nom_cuenta_bce,
    required this.sts_cuenta_bce,
  });

  factory Ifi.fromJson(Map<String, dynamic> json) {
    return Ifi(
      cod_cuenta_bce: json['cod_cuenta_bce'],
      nom_cuenta_bce: json['nom_cuenta_bce'],
      sts_cuenta_bce: json['sts_cuenta_bce'],
    );
  }
}