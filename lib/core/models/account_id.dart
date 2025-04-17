class AccountId {

  final int codProducto;
  final int codCuenta;

  AccountId({required this.codProducto, required this.codCuenta});

  factory AccountId.fromJson(Map<String, dynamic> json) {
    return AccountId(
      codProducto: json['codProducto'],
      codCuenta: json['codCuenta'],
    );
  }
}