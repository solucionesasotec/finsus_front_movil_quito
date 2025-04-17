// ignore_for_file: prefer_const_constructors

import 'package:bancamovil/core/models/partner_account.dart';
import 'package:bancamovil/features/products/providers/partner_accounts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownAccount extends StatefulWidget {
  // const DropdownProducts({super.key});
  final Function(String?) onAccountSelected;
  const DropdownAccount({required this.onAccountSelected});

  @override
  State<DropdownAccount> createState() => DropdownAccountState();
}

class DropdownAccountState extends State<DropdownAccount> {
  String? selectedValue;
  // Productos, con el codigo de producto
  // List<TypeCredit> typeCredits = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PartnerAccountsProvider>(context, listen: false).getAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerAccountsProvider>(
      builder: (context, accountProvider, child) {
        // Nota: Esta a la esucha de un cambio
        // typeCreditProvider.getTypeCredits();
        List<PartnerAccount> cuentas = accountProvider.accounts;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Producto de ahorro beneficiario',
            border: OutlineInputBorder(), // Aplica el borde
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          ),
          // hint: Text("Tipo de cuenta de beneficiario"),
          value: selectedValue, // Valor seleccionado actualmente

          items: cuentas.map((PartnerAccount item) {
            return DropdownMenuItem<String>(
              value: item.id.codProducto.toString(),
              child: Text(
                item.nomProducto,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),

          selectedItemBuilder: (BuildContext context) {
            return cuentas.map((PartnerAccount item) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  item.nomProducto,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },

          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue; // Actualiza el valor seleccionado
            });
            widget.onAccountSelected(newValue); // Llama al callback
          },
          validator: (value) {
            if (value == null) {
              return 'Selecciona un producto';
            }
            return null;
          },
        );
      },
    );
  }
}
