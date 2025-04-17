// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DropdownTypeProduct extends StatefulWidget {
  // const DropdownProducts({super.key});
  final Function(String?) onTypeProductSelected;
  const DropdownTypeProduct({required this.onTypeProductSelected});

  @override
  State<DropdownTypeProduct> createState() => DropdownTypeProductState();
}

class DropdownTypeProductState extends State<DropdownTypeProduct> {
  String? selectedValue;
  // Productos, con el codigo de producto
  List<Map<String,dynamic>> typeProduct = [
    {
      "id": '1',
      "nomProd": 'AHORROS',
    },
    {
      "id": '2',
      "nomProd": 'CORRIENTE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Tipo de producto',
        border: OutlineInputBorder(), // Aplica el borde
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      ),
      // hint: Text("Tipo de cuenta de beneficiario"),
      value: selectedValue, // Valor seleccionado actualmente

      items: typeProduct.map((Map<String,dynamic> item) {
        return DropdownMenuItem<String>(
          value: item['id'],
          child: Text(
            item['nomProd'],
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),

      selectedItemBuilder: (BuildContext context) {
        return typeProduct.map((Map<String,dynamic> item) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              item['nomProd'],
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },

      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue; // Actualiza el valor seleccionado
        });
        widget.onTypeProductSelected(newValue); // Llama al callback
      },
      validator: (value) {
        if (value == null) {
          return 'Selecciona un producto';
        }
        return null;
      },
    );
  }
}
