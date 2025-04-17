import 'package:bancamovil/features/login_recover_password/providers/recover_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  final TextEditingController _numCedulaController = TextEditingController();

  Future<void> _recoverPassword() async {
    if (_formKey.currentState!.validate()) {
      // Guardar el estado del formulario
      _formKey.currentState!.save();

      String numCedula = _numCedulaController.text;

      print("numCedula: $numCedula");

      final recoverPasswordProvider =
          Provider.of<RecoverPasswordProvider>(context, listen: false);

      try {
        await recoverPasswordProvider.changePassword(numCedula);

        if (recoverPasswordProvider.errorMessage == null) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60.0,
                  ),
                  content: Text(
                      'Estimado(a) ${recoverPasswordProvider.nomSocio} se ha enviado una clave temporal a su correo electrónico.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60.0,
                  ),
                  content: Text(recoverPasswordProvider.errorMessage ??
                      'Error al recuperar la contraseña'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                );
              });
        }

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Se ha enviado una clave temporal a su correo'),
        //   ),
        // );
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Error al recuperar la contraseña'),
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recoverPasswordProvider =
        Provider.of<RecoverPasswordProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Contraseña"),
        centerTitle: true,
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Asociamos el formulario con su clave
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ingresa tu número de cédula para verificar tu información",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _numCedulaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Número de cédula",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu número de cédula';
                    }
                    if (value.length != 10) {
                      return 'El número de cédula debe contener exactamente 10 dígitos';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Solo se permiten números';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _recoverPassword,
                    child: const Text("Recuperar Contraseña"),
                  ),
                ),
              ],
            ),
          ),
        ),
        /**
         * Bloque de carga
         */
        if (recoverPasswordProvider.isLoading)
          Container(
            color: Colors.black54, // Fondo semi-transparente
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.pink[400],
              ),
            ),
          ),
      ]),
    );
  }
}
