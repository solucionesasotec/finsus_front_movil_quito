// ignore_for_file: prefer_const_constructors

import 'package:bancamovil/core/models/product.dart';
import 'package:bancamovil/features/products/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownProducts extends StatefulWidget {
  // const DropdownProducts({super.key});
  final Function(String?) onProductSelected;
  const DropdownProducts({required this.onProductSelected});

  @override
  State<DropdownProducts> createState() => DropdownProductsState();
}

class DropdownProductsState extends State<DropdownProducts> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {

        List<Product> products = productProvider.products;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Tipo de cuenta beneficiario',
            border: OutlineInputBorder(), // Aplica el borde
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          ),
          // hint: Text("Tipo de cuenta de beneficiario"),
          value: selectedValue, // Valor seleccionado actualmente

          items: products.map((Product item) {
          // items: products.where((Product item) => item.codProducto != 4).map((Product item) {
            return DropdownMenuItem<String>(
              value: item.codProducto.toString(),
              child: Text(item.nomProducto),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue; // Actualiza el valor seleccionado
            });
            widget.onProductSelected(newValue); // Llama al callback
          },
          validator: (value) {
            if (value == null) {
              return 'Selecciona una cuenta';
            }
            return null;
          },
        );
      },
    );
  }
}
