// ignore_for_file: prefer_const_constructors

import 'package:bancamovil/core/models/type_credit.dart';
import 'package:bancamovil/features/extras/providers/type_credit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownTypeCredit extends StatefulWidget {
  // const DropdownProducts({super.key});
  final Function(String?) onTypeCreditSelected;
  const DropdownTypeCredit({required this.onTypeCreditSelected});

  @override
  State<DropdownTypeCredit> createState() => DropdownTypeCreditState();
}

class DropdownTypeCreditState extends State<DropdownTypeCredit> {
  String? selectedValue;
  // Productos, con el codigo de producto
  // List<TypeCredit> typeCredits = [];

  @override
  void initState() {
    super.initState();

    // usa provider 1 sola vez, pero si hay cambios en la base, se regresa <- screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TypeCreditProvider>(context, listen: false).getTypeCredits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TypeCreditProvider>(
      builder: (context, typeCreditProvider, child) {
        // Nota: Esta a la esucha de un cambio
        // typeCreditProvider.getTypeCredits();
        final tiposCredito = typeCreditProvider.typeCredits;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Tipo de crédito',
            border: OutlineInputBorder(), // Aplica el borde
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          ),
          // hint: Text("Tipo de cuenta de beneficiario"),
          value: selectedValue, // Valor seleccionado actualmente

          items: tiposCredito.map((TypeCredit item) {
            return DropdownMenuItem<String>(
              value: item.codTipoCredito.toString(),
              child: Text(
                item.nomTipoCredito,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),

          selectedItemBuilder: (BuildContext context) {
            return tiposCredito.map((TypeCredit item) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  item.nomTipoCredito,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },

          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue; // Actualiza el valor seleccionado
            });
            widget.onTypeCreditSelected(newValue); // Llama al callback
          },
          validator: (value) {
            if (value == null) {
              return 'Selecciona un tipo de crédito';
            }
            return null;
          },
        );
      },
    );
  }
}
