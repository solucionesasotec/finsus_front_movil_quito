import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _captureAndSaveScreenshot() async {
    try {
      // 1. Captura la pantalla directamente como bytes (Uint8List)
      // Ya no necesitamos guardarlo en un archivo temporal intermedio.
      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes == null) {
        debugPrint("Error: No se pudo capturar la imagen.");
        return;
      }

      // 2. Genera un nombre de archivo único usando una marca de tiempo
      String fileName = "Captura_${DateTime.now().millisecondsSinceEpoch}.png";

      // 3. Guarda los bytes directamente en la galería usando la nueva librería
      final result = await SaverGallery.saveImage(
        imageBytes,
        quality: 100,
        name: "test_$fileName",
        androidExistNotSave: false,
      );

      // 4. Verifica el resultado y notifica al usuario
      if (!mounted)
        return; // Verifica si el widget sigue activo antes de usar el contexto

      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Captura guardada correctamente en la galería'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Si la librería reporta un fallo (aunque no lance excepción)
        throw Exception("La galería reportó un error al intentar guardar.");
      }
    } catch (e) {
      // Manejo de errores (ej. permisos denegados)
      debugPrint("Error al guardar captura: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('No se pudo guardar la captura. Verifica los permisos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura y Guarda Pantalla'),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Captura y guarda esta pantalla en la galería',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _captureAndSaveScreenshot,
                child: const Text('Capturar y Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
