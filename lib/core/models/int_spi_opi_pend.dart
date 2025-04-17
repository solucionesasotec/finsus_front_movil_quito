class IntSpiOpiPend {
  final int codOficina;
  final String codTransaccion;
  final int num_transaccion;
  final int num_sec;
  final String cod_tipo_opi;
  final int num_opi;
  final int num_secuencial;
  // add more fields

  IntSpiOpiPend({
    required this.codOficina,
    required this.codTransaccion,
    required this.num_transaccion,
    required this.num_sec,
    required this.cod_tipo_opi,
    required this.num_opi,
    required this.num_secuencial,
  });

  factory IntSpiOpiPend.fromJson(Map<String, dynamic> json) {
    return IntSpiOpiPend(
      codOficina: json['codOficina'],
      codTransaccion: json['codTransaccion'],
      num_transaccion: json['num_transaccion'],
      num_sec: json['num_sec'],
      cod_tipo_opi: json['cod_tipo_opi'],
      num_opi: json['num_opi'],
      num_secuencial: json['num_secuencial'],
    );
  }
}