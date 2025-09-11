// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:bancamovil/features/transactions/provider/transaction_provider.dart';
import 'package:bancamovil/features/transactions/screens/transaction_receipt.dart';
import 'package:bancamovil/features/transactions/widgets/my_button_verification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VerificationInterbankScreen extends StatefulWidget {
  const VerificationInterbankScreen({super.key});

  @override
  State<VerificationInterbankScreen> createState() =>
      _VerificationInterbankScreenState();
}

class _VerificationInterbankScreenState
    extends State<VerificationInterbankScreen> {
  final _codeController = TextEditingController();
  bool isCodeValid = true;

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _verifyCode(context, smsProvider) async {
    final Map<String, dynamic> dataTransfer =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String producto = dataTransfer['producto'];
    String cuenta = dataTransfer['cuenta'];
    String monto = dataTransfer['monto'];
    String banco = dataTransfer['banco'];
    String nomBanco = dataTransfer['nomBanco']; // Recupera el nombre del banco
    String identificacion = dataTransfer['identificacion'];
    String beneficiario = dataTransfer['beneficiario'];
    String tipocuenta = dataTransfer['tipocuenta'];
    String descripcion = dataTransfer['descripcion'];
    String spiconcepto = dataTransfer['spiconcepto'];
    String ctaacreditar = dataTransfer['ctaacreditar'];
    String tipocuentaacreditar = dataTransfer['tipocuentaacreditar'];

    String nombreSocioOrdenante = dataTransfer['nombreSocioOrdenante'];
    String nombreSocio = dataTransfer['nombreSocio'];

    try {
      await smsProvider.validateSms(_codeController.text);

      if (smsProvider.isConfirmed) {
        print('Codigo validado !!');
        print('Send Transaccion prod: ${producto}');
        print('Send Transaccion cta: ${cuenta}');
        print('Send Transaccion monto: ${monto}');
        print('Send Transaccion banco: ${banco}');
        print('Send Transaccion id: ${identificacion}');
        print('Send Transaccion benef: ${beneficiario}');
        print('Send Transaccion tipoCta: ${tipocuenta}');
        print('Send Transaccion desc: ${descripcion}');
        print('Send Transaccion spiconcep: ${spiconcepto}');
        print('Send Transaccion ctaacred: ${ctaacreditar}');
        print('Send Transaccion tipoctaacred: ${tipocuentaacreditar}');

        print('Send Transaccion: ${nombreSocioOrdenante}');
        print('Send Transaccion: ${nombreSocio}');

        await smsProvider.interbankTransaction(
            producto,
            cuenta,
            monto,
            banco,
            identificacion,
            beneficiario,
            tipocuenta,
            descripcion,
            spiconcepto,
            ctaacreditar,
            tipocuentaacreditar);

        if (smsProvider.isInterbankComplete) {
          print('Transferencia interbancaria completa');

          String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());
          // _showSuccessDialog(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionReceipt(
                      fecha: fechaActual,
                      monto: monto,
                      cuentaOrigen: cuenta,
                      cuentaDestino: ctaacreditar,
                      referencia: descripcion,
                      nombreSocioOrdenante: nombreSocioOrdenante,
                      nombreSocio: nombreSocio,
                      nombreBanco: nomBanco,
                    )),
            (Route<dynamic> route) =>
                false, // Elimina todas las rutas anteriores
          );
        } else {
          if (smsProvider.errorMessage != null &&
              smsProvider.errorMessage!.isNotEmpty) {
            _showErrorDialog(context, smsProvider.errorMessage!);
          } else {
            _showErrorDialog(context, 'Ocurrió un error desconocido.');
          }
        }

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

                // Botón para verificar

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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transacción exitosa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'La transacción solicitada será debitada de su cuenta y acreditada a la cuenta destino en 24 hotas.'),
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
                //   (Route<dynamic> route) =>
                //       false, // Elimina todas las rutas anteriores
                // );
              },
            ),
          ],
        );
      },
    );
  }
}
