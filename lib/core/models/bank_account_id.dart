class BankAccountId {
  final String nomBanco;
  final String codCuenta;

  BankAccountId({
    required this.nomBanco,
    required this.codCuenta,
  });

  factory BankAccountId.fromJson(Map<String, dynamic> json){
    return BankAccountId(
      nomBanco: json['nomBanco'] ?? '',
      codCuenta: json['codCuenta'] ?? '');
  }
}