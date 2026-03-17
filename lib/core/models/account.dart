
import 'package:bancamovil/core/models/account_id.dart';

class Account {
  final AccountId id;
  final String? numCuentaRef;
  final String? fecApertura;
  final String? fecUltMovimiento;
  final String? stsCuenta;
  final String? fecStsCuenta;
  final String? txtReferencia;
  final double valSaldo;
  final double valEfectivo;
  final double valCheques;
  final double valBloqueado;
  final int codOficina;
  final int codUsrmod;
  final String? fecUsrmod;
  final int codOficialCuenta;
  final String? nomCuenta;
  // Add other fields

  Account({
    required this.id,
    required this.numCuentaRef,
    required this.fecApertura,
    required this.fecUltMovimiento,
    required this.stsCuenta,
    required this.fecStsCuenta,
    required this.txtReferencia,
    required this.valSaldo,
    required this.valEfectivo,
    required this.valCheques,
    required this.valBloqueado,
    required this.codOficina,
    required this.codUsrmod,
    required this.fecUsrmod,
    required this.codOficialCuenta,
    required this.nomCuenta,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: AccountId.fromJson(json['id']),
      numCuentaRef: json['numCuentaRef'],
      fecApertura: json['fecApertura'],
      fecUltMovimiento: json['fecUltMovimiento'],
      stsCuenta: json['stsCuenta'],
      fecStsCuenta: json['fecStsCuenta'],
      txtReferencia: json['txtReferencia'],
      valSaldo: json['valSaldo'],
      valEfectivo: json['valEfectivo'],
      valCheques: json['valCheques'],
      valBloqueado: json['valBloqueado'],
      codOficina: json['codOficina'],
      codUsrmod: json['codUsrmod'],
      fecUsrmod: json['fecUsrmod'],
      codOficialCuenta: json['codOficialCuenta'],
      nomCuenta: json['nomCuenta'],
    );
  }
}
