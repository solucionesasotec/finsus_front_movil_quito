// import 'package:bancamovil/core/models/account_id.dart';

class Credit {
  final int cod_producto;
  final int cod_cuenta;
  final String nom_destino;
  final double valCapital;
  final double numCuotas;
  final double valTasaInteres;
  final String fecPrestamo;
  final String fecVencimiento;
  final double cfValSaldo;
  final double numDiasMora;
  final String stsPrestamo;

  Credit({
    required this.cod_producto,
    required this.cod_cuenta,
    required this.nom_destino,
    required this.valCapital,
    required this.numCuotas,
    required this.valTasaInteres,
    required this.fecPrestamo,
    required this.fecVencimiento,
    required this.cfValSaldo,
    required this.numDiasMora,
    required this.stsPrestamo,
  });

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      cod_producto: json['cod_producto'],
      cod_cuenta: json['cod_cuenta'],
      nom_destino: json['nom_destino'],
      valCapital: json['valCapital'],
      numCuotas: json['numCuotas'],
      valTasaInteres: json['valTasaInteres'],
      fecPrestamo: json['fecPrestamo'],
      fecVencimiento: json['fecVencimiento'],
      cfValSaldo: json['cfValSaldo'],
      numDiasMora: json['numDiasMora'],
      stsPrestamo: json['stsPrestamo'],
    );
  }
}
