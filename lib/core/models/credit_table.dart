
class CreditTable {
  final double numCuota;
  final double valCapital;
  final double valInteres;
  final double valSaldoCapital;
  final double valSaldoInteres;
  final double valSaldoMora;
  final double seguro;
  final String fecVencimiento;
  final String estado;

  CreditTable({
    required this.numCuota,
    required this.valCapital,
    required this.valInteres,
    required this.valSaldoCapital,
    required this.valSaldoInteres,
    required this.valSaldoMora,
    required this.seguro,
    required this.fecVencimiento,
    required this.estado,
  });

  factory CreditTable.fromJson(Map<String, dynamic> json) {
    return CreditTable(
      numCuota: json['numCuota'],
      valCapital: json['valCapital'],
      valInteres: json['valInteres'],
      valSaldoCapital: json['valSaldoCapital'],
      valSaldoInteres: json['valSaldoInteres'],
      valSaldoMora: json['valSaldoMora'],
      seguro: json['seguro'],
      fecVencimiento: json['fecVencimiento'],
      estado: json['estado'],
    );
  }
}
