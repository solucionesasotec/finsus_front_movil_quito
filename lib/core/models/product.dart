// import 'package:bancamovil/core/models/account_id.dart';

class Product {
  final int codProducto;
  final String nomProducto;
  final String? codTipoProducto;
  final String? stsProducto;
  final String? txtFormato;
  final int codGrupo;

  Product({
    required this.codProducto,
    required this.nomProducto,
    required this.codTipoProducto,
    required this.stsProducto,
    required this.txtFormato,
    required this.codGrupo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      codProducto: json['codProducto'],
      nomProducto: json['nomProducto'],
      codTipoProducto: json['codTipoProducto'],
      stsProducto: json['stsProducto'],
      txtFormato: json['txtFormato'],
      codGrupo: json['codGrupo'],
    );
  }
}
