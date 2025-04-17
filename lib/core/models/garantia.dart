// import 'package:bancamovil/core/models/account_id.dart';

import 'package:bancamovil/core/models/garantia_id.dart';

class Garantia {
  final GarantiaId id;
  final String nomSocio;
  final String apeSocio;
  final double valCapital;
  final double valTasaInteres;
  final double valSaldo;
  final int numDiasMora;
  final double cfValSaldoPendiente;

  Garantia({
    required this.id,
    required this.nomSocio,
    required this.apeSocio,
    required this.valCapital,
    required this.valTasaInteres,
    required this.valSaldo,
    required this.numDiasMora,
    required this.cfValSaldoPendiente,
  });

  factory Garantia.fromJson(Map<String, dynamic> json) {
    return Garantia(
      id: GarantiaId.fromJson(json['id']),
      nomSocio: json['nomSocio'],
      apeSocio: json['apeSocio'],
      valCapital: json['valCapital'],
      valTasaInteres: json['valTasaInteres'],
      valSaldo: json['valSaldo'],
      numDiasMora: json['numDiasMora'],
      cfValSaldoPendiente: json['cfValSaldoPendiente'],
    );
  }
}
