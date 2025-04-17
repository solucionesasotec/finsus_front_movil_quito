// import 'dart:ffi';

class MovementId {
  final int cod_oficina;
  final String cod_transaccion;
  final int num_transaccion;

  MovementId({
    required this.cod_oficina,
    required this.cod_transaccion,
    required this.num_transaccion,
  });

  factory MovementId.fromJson(Map<String, dynamic> json) {
    return MovementId(
      cod_oficina: json['cod_oficina'],
      cod_transaccion: json['cod_transaccion'],
      num_transaccion: json['num_transaccion'],
    );
  }
}
