
import 'package:bancamovil/core/models/sgf_solc_credito_id.dart';

class SgfSolCredito {
  final SgfSolCreditoId id;
  final int codProductoSocio;
  final int codCuentaSocio;
  final int codSocio;
  final int numSolicitud;
  final int valCapital;
  // Add fields

  SgfSolCredito({
    required this.id,
    required this.codProductoSocio,
    required this.codCuentaSocio,
    required this.codSocio,
    required this.numSolicitud,
    required this.valCapital,
  });

  factory SgfSolCredito.fromJson(Map<String, dynamic> json) {
    return SgfSolCredito(
      id: SgfSolCreditoId.fromJson(json['id']),
      codProductoSocio: json['codProductoSocio'],
      codCuentaSocio: json['codCuentaSocio'],
      codSocio: json['codSocio'],
      numSolicitud: json['numSolicitud'],
      valCapital: json['valCapital'],
    );
  }
}
