
class ClasifCredit {
  final int codClasifCredito;
  final String nomClasifCredito;
  final String stsClasifCredito;
  final int codTipoCredito;
  final double valTasaMax;
  final double valTasaMin;
  final double valCapitalMax;
  final double valCapitalMin;
  final double numPlazoMax;
  final double numPlazoMin;

  ClasifCredit({
    required this.codClasifCredito,
    required this.nomClasifCredito,
    required this.stsClasifCredito,
    required this.codTipoCredito,
    required this.valTasaMax,
    required this.valTasaMin,
    required this.valCapitalMax,
    required this.valCapitalMin,
    required this.numPlazoMax,
    required this.numPlazoMin,
  });

  factory ClasifCredit.fromJson(Map<String, dynamic> json) {
    return ClasifCredit(
      codClasifCredito: json['codClasifCredito'],
      nomClasifCredito: json['nomClasifCredito'],
      stsClasifCredito: json['stsClasifCredito'],
      codTipoCredito: json['codTipoCredito'],
      valTasaMax: json['valTasaMax'],
      valTasaMin: json['valTasaMin'],
      valCapitalMax: json['valCapitalMax'],
      valCapitalMin: json['valCapitalMin'],
      numPlazoMax: json['numPlazoMax'],
      numPlazoMin: json['numPlazoMin'],
    );
  }
}
