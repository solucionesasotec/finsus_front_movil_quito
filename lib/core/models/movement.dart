// import 'dart:ffi';

import 'package:bancamovil/core/models/movementId.dart';

class Movement {
  final MovementId id;
  // final Long cod_producto;
  // final Long cod_cuenta;
  // final String fec_usrmod;
  final String? nom_transaccion;
  final String? sts_d_c;
  final DateTime? fecMovimiento;
  final double valEfectivo;
  final double valCheques;
  final double valSaldo;
  final String? txtReferencia;

  Movement({
    required this.id,
    // required this.cod_producto,
    // required this.cod_cuenta,
    // required this.fec_usrmod,
    required this.nom_transaccion,
    required this.sts_d_c,
    required this.fecMovimiento,
    required this.valEfectivo,
    required this.valCheques,
    required this.valSaldo,
    required this.txtReferencia,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: MovementId.fromJson(json['id']),
      // cod_producto: json['cod_producto'],
      // cod_cuenta: json['cod_cuenta'],
      // fec_usrmod: json['fec_usrmod'],
      nom_transaccion: json['nom_transaccion'],
      sts_d_c: json['sts_d_c'],
      fecMovimiento: json['fecMovimiento'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['fecMovimiento'])
          : null,
      valEfectivo: json['valEfectivo'],
      valCheques: json['valCheques'],
      valSaldo: json['valSaldo'],
      txtReferencia: json['txtReferencia'],
    );
  }
}
