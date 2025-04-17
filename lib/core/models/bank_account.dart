import 'package:bancamovil/core/models/bank_account_id.dart';

class BankAccount {
  final BankAccountId id;
  final String codTipoCuenta;
  final String codBanco;

  BankAccount({
    required this.id,
    required this.codTipoCuenta,
    required this.codBanco,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
        id: BankAccountId.fromJson(json['id']),
        codTipoCuenta: json['cod_tipo_cuenta'] ?? '',
        codBanco: json['cod_banco'] ?? '');
  }
}
