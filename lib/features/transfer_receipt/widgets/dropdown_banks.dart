import 'package:bancamovil/features/deposite_data/providers/bank_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bancamovil/core/models/bank_account.dart';

class DropdownBanks extends StatefulWidget {
  final Function(String?, String?) onBankSelected;
  const DropdownBanks({required this.onBankSelected});

  @override
  State<DropdownBanks> createState() => DropdownBanksState();
}

class DropdownBanksState extends State<DropdownBanks> {
  String? selectedValue;
  String? selectedCodCuenta;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BankAccountProvider>(context, listen: false).getBankAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankAccountProvider>(
      builder: (context, bankAccountProvider, child) {
        if (bankAccountProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (bankAccountProvider.errorMessage != null) {
          return Text(
            bankAccountProvider.errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 16),
          );
        }

        List<BankAccount> cuentas = bankAccountProvider.cuentasBanco;

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Selecciona una cuenta bancaria',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          ),
          value: selectedValue,
          items: cuentas.map((BankAccount cuenta) {
            return DropdownMenuItem<String>(
              value: cuenta.codBanco, // Usa el código de cuenta como valor
              child: Text(
                '${cuenta.id.codCuenta} - ${cuenta.id.nomBanco}',
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            final banco = cuentas.firstWhere((element) => element.codBanco == newValue);
            setState(() {
              selectedValue = newValue;
              selectedCodCuenta = banco.id.codCuenta;
            });
            widget.onBankSelected(newValue, selectedCodCuenta);
          },
          validator: (value) {
            if (value == null) {
              return 'Selecciona una banco';
            }
            return null;
          },
        );
      },
    );
  }
}
