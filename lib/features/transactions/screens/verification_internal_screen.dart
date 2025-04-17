// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:bancamovil/core/utils/constants.dart';
import 'package:intl/intl.dart';

import 'package:bancamovil/features/home/screens/home_screen.dart';
import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:bancamovil/features/transactions/provider/transaction_provider.dart';
import 'package:bancamovil/features/transactions/screens/transaction_receipt.dart';
import 'package:bancamovil/features/transactions/widgets/my_button_verification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationInternalScreen extends StatefulWidget {
  const VerificationInternalScreen({super.key});

  @override
  State<VerificationInternalScreen> createState() =>
      _VerificationInternalScreenState();
}

class _VerificationInternalScreenState
    extends State<VerificationInternalScreen> {
  final _codeController = TextEditingController();
  bool isCodeValid = true;

  Future<void> _verifyCode(context, smsProvider) async {
    final Map<String, dynamic> dataTransfer =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String producto = dataTransfer['producto'];
    String cuenta = dataTransfer['cuenta'];
    String monto = dataTransfer['monto'];
    String productoSocio = dataTransfer['productoSocio'];
    String cuentaSocio = dataTransfer['cuentaSocio'];
    String descripcion = dataTransfer['descripcion'];

    String nombreSocioOrdenante = dataTransfer['nombreSocioOrdenante'];
    String nombreSocio = dataTransfer['nombreSocio'];

    try {
      await smsProvider.validateSms(_codeController.text);

      if (smsProvider.isConfirmed) {
        print('Codigo validado !!');
        print('Send Transaccion Prod: ${producto}');
        print('Send Transaccion CuentaEnv: ${cuenta}');
        print('Send Transaccion Monto: ${monto}');
        print('Send Transaccion ProdDes: ${productoSocio}');
        print('Send Transaccion CuentaDes: ${cuentaSocio}');
        print('Send Transaccion Desc: ${descripcion}');

        print('Send Transaccion: ${nombreSocioOrdenante}');
        print('Send Transaccion: ${nombreSocio}');
        // await smsProvider.internalTransaction(
        //     '1', '360', '1.22', '1', '40', 'Prueba App');

        await smsProvider.internalTransaction(
            producto, cuenta, monto, productoSocio, cuentaSocio, descripcion);

        if (smsProvider.isInternalComplete) {
          print('Transferencia completa');
          String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());
          // _showSuccessDialog(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionReceipt(
                fecha: fechaActual,
                monto: monto,
                cuentaOrigen: cuenta,
                cuentaDestino: cuentaSocio,
                referencia: descripcion,
                nombreSocioOrdenante: nombreSocioOrdenante,
                nombreSocio: nombreSocio,
                nombreBanco: appEmpresa,
              ),
            ),
            (Route<dynamic> route) => false,
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${smsProvider.errorMessage}'),
            backgroundColor: Colors.red[400],
          ),
        );

        // return;
      } else {
        print('Codigo no validado');
        setState(() {
          isCodeValid = false;
        });
      }
    } catch (e) {
      print('Error envio sms fallido: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final smsProvider = Provider.of<TransactionProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Verificación de transacción'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Colocar el correo del socio
                  'Ingresa el código de verificación enviado al correo electrónico:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Campo para ingresar el código
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Código de verificación',
                    errorText: isCodeValid ? null : 'Código incorrecto',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                SizedBox(height: 20),
                MyButtonVerification(
                    onTap: () => _verifyCode(context, smsProvider)),
              ],
            ),
          ),
        ),

        /**
         * Bloque de carga al iniciar sesion
         */
        if (smsProvider.isLoading)
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

  // Función para verificar el código
  // void _verifyCode() {
  //   String enteredCode = _codeController.text;

  //   // Simulación de verificación (en la realidad sería una petición al backend)
  //   if (enteredCode == "432199") {
  //     _showSuccessDialog(context);

  //     // Navigator.pushReplacementNamed(context, '/success'); // Navegar a una pantalla de éxito
  //   } else {
  //     setState(() {
  //       isCodeValid = false;
  //     });
  //   }
  // }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transacción exitosa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('La transacción se ha realizado correctamente.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (context) => TransactionReceipt()),
                //   (Route<dynamic> route) => false,
                // );
              },
            ),
          ],
        );
      },
    );
  }
}
