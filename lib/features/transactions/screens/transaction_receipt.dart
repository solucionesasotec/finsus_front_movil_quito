// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:bancamovil/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:path_provider/path_provider.dart';

class TransactionReceipt extends StatefulWidget {
  // const TransactionReceipt({super.key});
  final String fecha;
  final String monto;
  final String cuentaOrigen;
  final String cuentaDestino;
  final String referencia;

  final String nombreSocioOrdenante;
  final String nombreSocio;
  final String nombreBanco;

  // Constructor para recibir los parámetros
  TransactionReceipt({
    required this.fecha,
    required this.monto,
    required this.cuentaOrigen,
    required this.cuentaDestino,
    required this.referencia,
    required this.nombreSocioOrdenante,
    required this.nombreSocio,
    required this.nombreBanco,
  });

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _captureAndSaveScreenshot() async {
    try {
      // 1. Captura la pantalla como Uint8List (bytes)
      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes == null) return;

      // 2. Guarda directamente en la galería usando los bytes
      // El nombre del archivo debe ser único para evitar conflictos
      String fileName =
          "Comprobante_${widget.cuentaOrigen}_${DateTime.now().millisecondsSinceEpoch}.png";

      final result = await SaverGallery.saveImage(
        imageBytes,
        quality: 100,
        name: "Transferencia_$fileName",
        androidExistNotSave: false,
        // name: fileName,
        // androidExistNotSave: false, // Guardar siempre aunque exista uno igual
      );

      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comprobante guardado en la galería')),
        );
      } else {
        throw Exception("Error al guardar");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> dataTransfer =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white, // Fondo sólido para evitar transparencia
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/images/logo_finsus.png',
                        height: 75.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 60,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Transferencia Exitosa',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Comprobante de Transferencia',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Fecha: ${widget.fecha}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Monto: \$${widget.monto}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Detalle de Ordenante',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Socio: ${widget.nombreSocioOrdenante}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'N° Cuenta: ${widget.cuentaOrigen}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Detalle de Destino',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (!widget.nombreSocio.contains('NaN'))
                              Text(
                                'Beneficiario: ${widget.nombreSocio}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            Text(
                              'N° Cuenta: ${widget.cuentaDestino}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Institución: ${widget.nombreBanco}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: Icon(Icons.home, color: Colors.black),
                  label: Text('Finalizar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    foregroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _captureAndSaveScreenshot,
                  icon: Icon(Icons.save_alt, color: Colors.black),
                  label: const Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    foregroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
