class GarantiaId {

  final String numId;
  final String fecPrestamo;
  final String fecVencimiento;

  GarantiaId({required this.numId, required this.fecPrestamo, required this.fecVencimiento});

  factory GarantiaId.fromJson(Map<String, dynamic> json) {
    return GarantiaId(
      numId: json['numId'],
      fecPrestamo: json['fecPrestamo'],
      fecVencimiento: json['fecVencimiento'],
    );
  }
}