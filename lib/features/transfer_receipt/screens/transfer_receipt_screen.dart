// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:bancamovil/core/models/partner_account.dart';
import 'package:bancamovil/core/models/int_spi_opi_pend.dart';
import 'package:bancamovil/features/home/screens/home_screen.dart';
import 'package:bancamovil/features/products/providers/partner_accounts_provider.dart';
import 'package:bancamovil/features/transfer_receipt/providers/comprobante_dep_provider.dart';
import 'package:bancamovil/features/transfer_receipt/providers/int_spi_opi_pend_provider.dart';
import 'package:bancamovil/features/transfer_receipt/widgets/dropdown_account.dart';
import 'package:bancamovil/features/transfer_receipt/widgets/dropdown_banks.dart';
import 'package:bancamovil/features/transfer_receipt/widgets/my_button_save_receipt.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TransferReceiptScreen extends StatefulWidget {
  const TransferReceiptScreen({super.key});

  @override
  State<TransferReceiptScreen> createState() => _TransferReceiptScreenState();
}

class _TransferReceiptScreenState extends State<TransferReceiptScreen> {
  final _formKeySaveReceipt = GlobalKey<FormState>();
  String? selectedTypeProduct;
  final _cuentaEnviaController = TextEditingController();
  String? selectedProductBenef;
  String? selectedBank;
  String? selectedCodCuenta;
  final _montoController = TextEditingController();
  XFile? receiptImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _save() async {
    if (_formKeySaveReceipt.currentState!.validate() == true) {
      _formKeySaveReceipt.currentState?.save();

      print('--- Form Save Receipt OK');

      print('Producto: $selectedProductBenef');
      print('Banco: $selectedBank');
      print('Monto: ${_montoController.text}');
      print('IMG: ${receiptImage}');
      String? base64Image = await _convertImageToBase64();
      // print('IMG Base64: ${base64Image}');

      String strTypeProduct = selectedTypeProduct ?? 'NaN';
      String strProductBenef = selectedProductBenef ?? 'NaN';
      String strBank = selectedBank ?? 'NaN';
      String strCodCuenta = selectedCodCuenta ?? 'NaN';
      String strImgBase64 = base64Image ?? 'NaN';

      String monto = _montoController.text;
      String cuentaEnvia = _cuentaEnviaController.text;

      final intSpiOpiPendProvider =
          Provider.of<IntSpiOpiPendProvider>(context, listen: false);
      final accountProvider =
          Provider.of<PartnerAccountsProvider>(context, listen: false);
      List<PartnerAccount> cuentaFilter = accountProvider.accounts
          .where((account) =>
              account.id.codProducto == int.tryParse(selectedProductBenef!))
          .toList();
      int codCuenta = cuentaFilter[0].id.codCuenta;

      late IntSpiOpiPend depositeResp;
      try {
        print('--- llega aca');
        await intSpiOpiPendProvider.createDeposite(
            '0', // strTypeProduct
            strCodCuenta, // 'cuentaEnvia'
            strProductBenef,
            codCuenta.toString(),
            strBank,
            monto,
            strImgBase64);
        depositeResp = intSpiOpiPendProvider.intSpiOpiPend;

        print("-------------------------");
        print("Valores necesario que envia");
        print("strTypeProduct: 0");
        print("cuentaEnvia DATO NUEVO: $strCodCuenta");
        print("strProductBenef: $strProductBenef");
        print("codCuenta NUEVO DATO ${codCuenta.toString()}");
        print("strBank $strBank");
        print("monto $monto");
        print("-------------------------");

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text('Carga de comprobante'),
            content: Text('El comprobante se ha registrado correctamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.of(ctx).pushReplacementNamed('/login');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) =>
                        false, // Elimina todas las rutas anteriores
                  );
                },
                child: Text('Aceptar'),
              ),
            ],
          ),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //         "Proceso OK: ${depositeResp.codTransaccion} - ${depositeResp.num_transaccion}"),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } catch (e) {
        print('Error en crear deposito Backend $e');
      }
    } else {
      print('--- Form Save Receipt NO VALIDO');
    }
  }

  String? _validateImage() {
    if (receiptImage == null) {
      return 'Debes seleccionar un comprobante';
    }
    return null;
  }

  void handleTypeProductSelected(String? concept) {
    setState(() {
      selectedTypeProduct = concept;
    });
  }

  void handleAccountSelected(String? concept) {
    setState(() {
      selectedProductBenef = concept;
    });
  }

  void handleBankSelected(String? concept, String? codCuenta) {
    setState(() {
      selectedBank = concept;
      selectedCodCuenta = codCuenta;

    });
  }

  // Seleccionar imagen
  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      receiptImage = pickedImage;
    });
  }

  // Convertir en Base64
  Future<String?> _convertImageToBase64() async {
    if (receiptImage == null) return null;
    final bytes = await File(receiptImage!.path).readAsBytes();
    return base64Encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final intSpiOpiPendProvider = Provider.of<IntSpiOpiPendProvider>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Carga de Comprobante'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKeySaveReceipt,
              child: ListView(
                children: [
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: Card(
                  //     elevation: 4,
                  //     margin: EdgeInsets.only(bottom: 16),
                  //     color: Colors.amber[300],
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           // Círculo amarillo
                  //           Container(
                  //             width: 30, // Puedes ajustar el tamaño aquí
                  //             height: 30, // También ajustar aquí
                  //             decoration: BoxDecoration(
                  //               color: Colors.yellow,
                  //               shape: BoxShape.circle,
                  //             ),
                  //           ),
                  //           SizedBox(
                  //               width:
                  //                   16), // Espacio entre el círculo y el texto

                  //           // Texto
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   'BANCO DEL PICHINCHA',
                  //                   style: TextStyle(
                  //                     fontSize: 20,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                     height:
                  //                         8), // Separación entre líneas de texto
                  //                 Text.rich(
                  //                   TextSpan(
                  //                     children: [
                  //                       TextSpan(
                  //                           text: 'Cuenta: ',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.bold)),
                  //                       TextSpan(text: 'AHORROS'),
                  //                     ],
                  //                   ),
                  //                   style: TextStyle(fontSize: 16),
                  //                 ),
                  //                 Text.rich(
                  //                   TextSpan(
                  //                     children: [
                  //                       TextSpan(
                  //                           text: 'N° de Cuenta: ',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.bold)),
                  //                       TextSpan(text: '2210458581'),
                  //                     ],
                  //                   ),
                  //                   style: TextStyle(fontSize: 16),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // SizedBox(
                  //   width: double.infinity,
                  //   child: Card(
                  //     elevation: 4,
                  //     margin: EdgeInsets.only(bottom: 16),
                  //     color: Colors.red[200],
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           // Círculo amarillo
                  //           Container(
                  //             width: 30, // Puedes ajustar el tamaño aquí
                  //             height: 30, // También ajustar aquí
                  //             decoration: BoxDecoration(
                  //               color: Colors.red,
                  //               shape: BoxShape.circle,
                  //             ),
                  //           ),
                  //           SizedBox(
                  //               width:
                  //                   16), // Espacio entre el círculo y el texto

                  //           // Texto
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   'BANCO PROCREDIT',
                  //                   style: TextStyle(
                  //                     fontSize: 20,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                     height:
                  //                         8), // Separación entre líneas de texto
                  //                 Text.rich(
                  //                   TextSpan(
                  //                     children: [
                  //                       TextSpan(
                  //                           text: 'Cuenta: ',
                  //                           style: TextStyle(
                  //                                fontWeight: FontWeight.bold)),
                  //                       TextSpan(text: 'CORRIENTE'),
                  //                     ],
                  //                   ),
                  //                   style: TextStyle(fontSize: 16),
                  //                 ),
                  //                 Text.rich(
                  //                   TextSpan(
                  //                     children: [
                  //                       TextSpan(
                  //                           text: 'N° de Cuenta: ',
                  //                           style: TextStyle(
                  //                                fontWeight: FontWeight.bold)),
                  //                       TextSpan(text: '024036196892'),
                  //                     ],
                  //                   ),
                  //                   style: TextStyle(fontSize: 16),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Opciones de bancos
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: DropdownBanks(
                          onBankSelected: handleBankSelected,
                        ))
                      ],
                    ),
                  ),

                  // Select Type Product emit
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16.0),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Expanded(
                  //           child: DropdownTypeProduct(
                  //         onTypeProductSelected: handleTypeProductSelected,
                  //       ))
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 15),

                  // TextFormField(
                  //   controller: _cuentaEnviaController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Nro de cuenta',
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   keyboardType: TextInputType.number,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Campo onbligatorio';
                  //     }
                  //     if (double.tryParse(value) == null) {
                  //       return 'Ingrese un número válido';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 15),

                  // Opciones de productos socio
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: DropdownAccount(
                          onAccountSelected: handleAccountSelected,
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _montoController,
                    decoration: InputDecoration(
                      labelText: 'Monto de la transferencia',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo onbligatorio';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  // Botón para cargar imagen del comprobante
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      // margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Buscar o seleccionar imagen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Validación de imagen
                  FormField(
                    validator: (value) => _validateImage(),
                    builder: (FormFieldState state) {
                      return state.hasError
                          ? Text(
                              state.errorText ?? '',
                              style: TextStyle(color: Colors.red),
                            )
                          : Container();
                    },
                  ),
                  SizedBox(height: 20),

                  // Previsualización de la imagen seleccionada
                  Center(
                    child: receiptImage != null
                        ? Container(
                            width: 200,
                            height: 300,
                            child: Image.file(
                              File(receiptImage!.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              ),
                              Text(
                                'No se ha seleccionado el comprobante',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                  ),

                  SizedBox(height: 20),
                  MyButtonSaveReceipt(
                    onTap: () => _save(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        /**
             * Bloque de carga
             */
        if (intSpiOpiPendProvider.isLoading)
          Container(
            color: Colors.black54, // Fondo semi-transparente
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.pink[400],
              ),
            ),
          ),
      ],
    );
  }
}
