
class SgfSolCreditoId {
  final int codProducto;
  final int codCuenta;

  SgfSolCreditoId({
    required this.codProducto,
    required this.codCuenta,
  });

  factory SgfSolCreditoId.fromJson(Map<String, dynamic> json) {
    return SgfSolCreditoId(
      codProducto: json['codProducto'],
      codCuenta: json['codCuenta'],
    );
  }
}
