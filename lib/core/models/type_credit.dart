
class TypeCredit {
  final int codTipoCredito;
  final String nomTipoCredito;
  final String stsTipoCredito;
  final int numDiasMorosidad;
  final String codCuentaContabProvInc;

  TypeCredit({
    required this.codTipoCredito,
    required this.nomTipoCredito,
    required this.stsTipoCredito,
    required this.numDiasMorosidad,
    required this.codCuentaContabProvInc,
  });

  factory TypeCredit.fromJson(Map<String, dynamic> json) {
    return TypeCredit(
      codTipoCredito: json['codTipoCredito'],
      nomTipoCredito: json['nomTipoCredito'],
      stsTipoCredito: json['stsTipoCredito'],
      numDiasMorosidad: json['numDiasMorosidad'],
      codCuentaContabProvInc: json['codCuentaContabProvInc'],
    );
  }
}
