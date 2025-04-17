// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DropdownConcepts extends StatefulWidget {
  final Function(String?) onConceptSelected;
  const DropdownConcepts({required this.onConceptSelected});

  @override
  State<DropdownConcepts> createState() => DropdownConceptsState();
}

class DropdownConceptsState extends State<DropdownConcepts> {
  String? selectedValue;
  // Productos, con el codigo de producto
  List<Map<String, dynamic>> concepts = [
    {
      "cod_tipo": "P",
      "cod_concepto": 1,
      "nom_concepto": "TRANSFERENCIA ENTRE CLIENTES",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 2,
      "nom_concepto": "PAGO NOMINA",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 3,
      "nom_concepto": "PAGO DE SERVICIOS EVENTUALES",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 4,
      "nom_concepto": "PAGO DE SERVICIOS PROGRAMADOS",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 5,
      "nom_concepto": "PAGO RENDIMIENTO DE INVERSIÓN",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 6,
      "nom_concepto": "RENDIMIENTOS FINANCIEROS",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 7,
      "nom_concepto": "PAGO IMPUESTO PREDIAL",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 8,
      "nom_concepto": "SERVICIOS COMERCIO EXTERIOR",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 9,
      "nom_concepto": "REMESAS DEL EXTERIOR",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 10,
      "nom_concepto": "PRESTAMOS QUIROGRAFARIOS IESS",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 11,
      "nom_concepto": "PAGO A PRODUCTORES BANANEROS",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 12,
      "nom_concepto": "VIÁTICOS",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 13,
      "nom_concepto": "PAGOS AL BCE(ADMINISTRACIÓN DE ACTIVOS)",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 14,
      "nom_concepto": "PAGO PROVEEDORES",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 15,
      "nom_concepto": "PAGO CONSUMOS TARJETA DE CREDITO",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 16,
      "nom_concepto": "PAGO ESTABLECIMIENTOS TARJETA DE CREDITO",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 17,
      "nom_concepto": "PAGOS VARIOS",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 18,
      "nom_concepto": "LICENCIAS DE IMPORTACION",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 50,
      "nom_concepto": "OTROS PAGOS - SOLO SECTOR PUBLICO",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 51,
      "nom_concepto":
          "PAGO REMUNERACIONES SECTOR PUBLICO (DCTO 571 del 22-07-03)",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 52,
      "nom_concepto": "PAGO PENSIONES JUBILADOS –SECTOR PUBLICO",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 53,
      "nom_concepto": "PAGO FONDOS DE RESERVA (SECTOR PUBLICO)",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 61,
      "nom_concepto": "COBRO APORTES IESS",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 70,
      "nom_concepto": "PAGO DEUDA PUBLICA",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 98,
      "nom_concepto": "DEVOLUCIÓN DE IMPUESTOS SECTOR PUBLICO",
      "sts_concepto": "A"
    },
    {
      "cod_tipo": "P",
      "cod_concepto": 99,
      "nom_concepto": "DEVOLUCIÓN ORDEN DE  PAGO NO EFECTUADA (SOLO USO BCE)",
      "sts_concepto": "A"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Seleccionar un concepto',
        border: OutlineInputBorder(), // Aplica el borde
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      ),
      // hint: Text("Tipo de cuenta de beneficiario"),
      value: selectedValue, // Valor seleccionado actualmente

      items: concepts.map((Map<String, dynamic> item) {
        return DropdownMenuItem<String>(
          value: item['cod_concepto'].toString(),
          child: Text(
            item['nom_concepto'],
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) {
        return concepts.map((Map<String, dynamic> item) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              item['nom_concepto'],
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue; // Actualiza el valor seleccionado
        });
        widget.onConceptSelected(newValue); // Llama al callback
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
