// ignore_for_file: file_names

class InvestmentId {

  final int codProducto;
  final int codCuenta;

  InvestmentId({required this.codProducto, required this.codCuenta});

  factory InvestmentId.fromJson(Map<String, dynamic> json) {
    return InvestmentId(
      codProducto: json['codProducto'],
      codCuenta: json['codCuenta'],
    );
  }
}