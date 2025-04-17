// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DropdownAccountType extends StatefulWidget {
  // const DropdownProducts({super.key});
  final Function(String?) onAccountTypeSelected;
  const DropdownAccountType({required this.onAccountTypeSelected});

  @override
  State<DropdownAccountType> createState() => DropdownAccountTypeState();
}

class DropdownAccountTypeState extends State<DropdownAccountType> {
  String? selectedValue;
  // Productos, con el codigo de producto
  List<Map<String, dynamic>> banks = [
    {
      "id": 2,
      "nomCuenta": 'CTA. AHORROS',
    },
    {
      "id": 1,
      "nomCuenta": 'CTA. CORRIENTE',
    },
    {
      "id": 3,
      "nomCuenta": 'CTA. CONTABLE',
    },
    {
      "id": 4,
      "nomCuenta": 'TARJETA DE CRÉDITO',
    },
    {
      "id": 5,
      "nomCuenta": 'CTA. ESPECIAL DE PAGOS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Seleccionar tipo de cuenta',
        border: OutlineInputBorder(), // Aplica el borde
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical:18.0),
      ),
      // hint: Text("Tipo de cuenta de beneficiario"),
      value: selectedValue, // Valor seleccionado actualmente

      items: banks.map((Map<String, dynamic> item) {
        return DropdownMenuItem<String>(
          value: item['id'].toString(),
          child: Text(item['nomCuenta']),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue; // Actualiza el valor seleccionado
        });
        widget.onAccountTypeSelected(newValue); // Llama al callback
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obligatorio';
        }
        return null;
      },
    );
  }
}
