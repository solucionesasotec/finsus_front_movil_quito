import 'package:bancamovil/core/models/partner_account_id.dart';

class PartnerAccount {
  final PartnerAccountId id;
  final String nomProducto;
  final double valSaldo;
  final double valEfectivo;
  final double valCheques;
  final double valBloqueado;
  final String fecApertura;
  final String stsCuenta;

  PartnerAccount({
    required this.id,
    required this.nomProducto,
    required this.valSaldo,
    required this.valEfectivo,
    required this.valCheques,
    required this.valBloqueado,
    required this.fecApertura,
    required this.stsCuenta,
  });

  factory PartnerAccount.fromJson(Map<String, dynamic> json) {
    return PartnerAccount(
      id: PartnerAccountId.fromJson(json['id']),
      nomProducto: json['nomProducto'],
      valSaldo: json['valSaldo'],
      valEfectivo: json['valEfectivo'],
      valCheques: json['valCheques'],
      valBloqueado: json['valBloqueado'],
      fecApertura: json['fecApertura'],
      stsCuenta: json['stsCuenta'],
    );
  }
}
