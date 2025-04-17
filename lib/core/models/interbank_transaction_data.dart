class InterBankTransactionData {
  final int a_sts_retorno;
  final int li_cod_oficina;
  final String ls_cod_transaccion;
  final int ldo_num_transaccion;

  InterBankTransactionData({
    required this.a_sts_retorno,
    required this.li_cod_oficina,
    required this.ls_cod_transaccion,
    required this.ldo_num_transaccion,
  });

  factory InterBankTransactionData.fromJson(Map<String, dynamic> json) {
    return InterBankTransactionData(
      a_sts_retorno: json['a_sts_retorno'],
      li_cod_oficina: json['li_cod_oficina'],
      ls_cod_transaccion: json['ls_cod_transaccion'],
      ldo_num_transaccion: json['ldo_num_transaccion'],
    );
  }
}
