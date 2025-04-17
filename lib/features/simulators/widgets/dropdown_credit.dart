// ignore_for_file: prefer_const_constructors

import 'package:bancamovil/core/models/clasif_credit.dart';
import 'package:bancamovil/features/extras/providers/clasif_credit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownCredit extends StatefulWidget {
  // const DropdownProducts({super.key});
  final Function(String?) onCreditSelected;
  final String? codTypeCredit;
  const DropdownCredit(
      {required this.onCreditSelected, required this.codTypeCredit});

  @override
  State<DropdownCredit> createState() => DropdownCreditState();
}

class DropdownCreditState extends State<DropdownCredit> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClasifCreditProvider>(
      builder: (context, typeCreditProvider, child) {
        int codTipoCred =
            widget.codTypeCredit != null ? int.parse(widget.codTypeCredit!) : 0;

        List<ClasifCredit> clasifCreditos = [];
        try {
          typeCreditProvider.getClasifCredits(codTipoCred);
          clasifCreditos = typeCreditProvider.clasifCredits;
        } catch (e) {
          clasifCreditos = [];
        }

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Crédito',
            border: OutlineInputBorder(), // Aplica el borde
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          ),
          // hint: Text("Tipo de cuenta de beneficiario"),
          value: selectedValue, // Valor seleccionado actualmente

          items: clasifCreditos.map((ClasifCredit item) {
            return DropdownMenuItem<String>(
              // value: item.codClasifCredito.toString(),
              value: item.codClasifCredito.toString(),
              child: Text(item.nomClasifCredito),
            );
          }).toList(),

          selectedItemBuilder: (BuildContext context) {
            return clasifCreditos.map((ClasifCredit item) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  item.nomClasifCredito,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            }).toList();
          },
          
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue; // Actualiza el valor seleccionado
            });
            widget.onCreditSelected(newValue); // Llama al callback
          },
          validator: (value) {
            if (value == null) {
              return 'Selecciona un crédito';
            }
            return null;
          },
        );
      },
    );
  }
}
