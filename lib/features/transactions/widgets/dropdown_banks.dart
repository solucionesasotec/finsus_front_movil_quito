// // ignore_for_file: prefer_const_constructors

// import 'package:bancamovil/core/models/ifi.dart';
// import 'package:bancamovil/features/extras/providers/ifi_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DropdownBanks extends StatefulWidget {
//   // const DropdownProducts({super.key});
//   final Function(String?) onBankSelected;
//   const DropdownBanks({required this.onBankSelected});

//   @override
//   State<DropdownBanks> createState() => DropdownBanksState();
// }

// class DropdownBanksState extends State<DropdownBanks> {
//   String? selectedValue;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<IfiProvider>(context, listen: false).getIfis();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<IfiProvider>(
//       builder: (context, ifiProvider, child) {
//         List<Ifi> banks = ifiProvider.ifis;

//         return DropdownButtonFormField<String>(
//           decoration: InputDecoration(
//             labelText: 'Seleccionar institucion',
//             border: OutlineInputBorder(), // Aplica el borde
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
//           ),
//           // hint: Text("Tipo de cuenta de beneficiario"),
//           value: selectedValue, // Valor seleccionado actualmente

//           items: banks.map((Ifi item) {
//             return DropdownMenuItem<String>(
//               value: item.cod_cuenta_bce.toString(),
//               child: Text(
//                 item.nom_cuenta_bce,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             );
//           }).toList(),

//           selectedItemBuilder: (BuildContext context) {
//             return banks.map((Ifi item) {
//               return SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.7,
//                 child: Text(
//                   item.nom_cuenta_bce,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//               );
//             }).toList();
//           },
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedValue = newValue; // Actualiza el valor seleccionado
//             });
//             widget.onBankSelected(newValue); // Llama al callback
//           },
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Campo obligatorio';
//             }
//             return null;
//           },
//         );
        
//       },
//     );
//   }
// }

import 'package:bancamovil/core/models/ifi.dart';
import 'package:bancamovil/features/extras/providers/ifi_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownBanks extends StatefulWidget {
  final Function(String?, String?) onBankSelected;
  const DropdownBanks({required this.onBankSelected});

  @override
  State<DropdownBanks> createState() => DropdownBanksState();
}

class DropdownBanksState extends State<DropdownBanks> {
  String? selectedCode;
  String? selectedName;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IfiProvider>(context, listen: false).getIfis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IfiProvider>(
      builder: (context, ifiProvider, child) {
        List<Ifi> banks = ifiProvider.ifis;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Seleccionar institución',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          ),
          value: selectedCode, // Valor seleccionado actualmente

          items: banks.map((Ifi item) {
            return DropdownMenuItem<String>(
              value: item.cod_cuenta_bce.toString(),
              child: Text(
                item.nom_cuenta_bce,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),

          selectedItemBuilder: (BuildContext context) {
            return banks.map((Ifi item) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  item.nom_cuenta_bce,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            }).toList();
          },
          onChanged: (String? newValue) {
            final selectedBank = banks.firstWhere((bank) => bank.cod_cuenta_bce.toString() == newValue);
            setState(() {
              selectedCode = newValue; // Actualiza el código seleccionado
              selectedName = selectedBank.nom_cuenta_bce; // Actualiza el nombre seleccionado
            });
            widget.onBankSelected(selectedCode, selectedName); // Llama al callback con ambos valores
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obligatorio';
            }
            return null;
          },
        );
      },
    );
  }
}