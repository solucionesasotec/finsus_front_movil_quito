class PartnerAccountId {

  final int codProducto;
  final int codCuenta;

  PartnerAccountId({required this.codProducto, required this.codCuenta});

  factory PartnerAccountId.fromJson(Map<String, dynamic> json) {
    return PartnerAccountId(
      codProducto: json['codProducto'],
      codCuenta: json['codCuenta'],
    );
  }
}