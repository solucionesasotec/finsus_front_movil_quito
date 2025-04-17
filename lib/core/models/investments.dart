
import 'package:bancamovil/core/models/Investment_id.dart';

class Investment {
  final InvestmentId id;
  final String nomProducto;
  final String stsDeposito;
  final String fecVencimiento;
  final String fecDeposito;
  final double numPlazo;
  final double valDeposito;
  final double valTasaInteres;
  final double valTasaImpuesto;
  final double valInteres;
  final double valImpuesto;

  Investment({
    required this.id,
    required this.nomProducto,
    required this.stsDeposito,
    required this.fecVencimiento,
    required this.fecDeposito,
    required this.numPlazo,
    required this.valDeposito,
    required this.valTasaInteres,
    required this.valTasaImpuesto,
    required this.valInteres,
    required this.valImpuesto,
  });

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: InvestmentId.fromJson(json['id']),
      nomProducto: json['nomProducto'],
      stsDeposito: json['stsDeposito'],
      fecVencimiento: json['fecVencimiento'],
      fecDeposito: json['fecDeposito'],
      numPlazo: json['numPlazo'],
      valDeposito: json['valDeposito'],
      valTasaInteres: json['valTasaInteres'],
      valTasaImpuesto: json['valTasaImpuesto'],
      valInteres: json['valInteres'],
      valImpuesto: json['valImpuesto'],
    );
  }
}
