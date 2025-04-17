// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DropdownIdType extends StatefulWidget {
  // const DropdownProducts({super.key});
  final Function(String?) onIdTypeSelected;
  const DropdownIdType({required this.onIdTypeSelected});

  @override
  State<DropdownIdType> createState() => DropdownIdTypeState();
}

class DropdownIdTypeState extends State<DropdownIdType> {
  String? selectedValue;
  // Productos, con el codigo de producto
  List<Map<String, dynamic>> banks = [
    {
      "id": 0,
      "nomId": 'CÉDULA',
    },
    {
      "id": 1,
      "nomId": 'RUC',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Seleccionar tipo de identificación',
        border: OutlineInputBorder(), // Aplica el borde
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical:18.0),
      ),
      // hint: Text("Tipo de cuenta de beneficiario"),
      value: selectedValue, // Valor seleccionado actualmente

      items: banks.map((Map<String, dynamic> item) {
        return DropdownMenuItem<String>(
          value: item['id'].toString(),
          child: Text(item['nomId']),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue; // Actualiza el valor seleccionado
        });
        widget.onIdTypeSelected(newValue); // Llama al callback
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
