
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _captureAndSaveScreenshot() async {
    // Captura la pantalla
    final image = await screenshotController.capture();

    if (image == null) return;

    // Guarda la imagen en un directorio temporal
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/screenshot.png';
    final imageFile = await File(imagePath).create();
    await imageFile.writeAsBytes(image);

    // Guarda la imagen en la galería
    await GallerySaver.saveImage(imageFile.path, albumName: 'Screenshots');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Captura guardada en la galería')),
    );
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
