// ignore_for_file: prefer_const_constructors

import 'package:bancamovil/core/models/web_login.dart';
import 'package:bancamovil/features/login/screens/login_screen.dart';
import 'package:bancamovil/features/login_change_password/providers/web_login_provider.dart';
import 'package:bancamovil/features/login_change_password/wigets/my_button_confirm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureTextOld = true;
  bool _obscureTextNew = true;
  bool _obscureTextConfirm = true;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // String _confirmPassword = '';

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureTextOld = !_obscureTextOld;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureTextNew = !_obscureTextNew;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureTextConfirm = !_obscureTextConfirm;
    });
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      // Guardar el estado del formulario
      _formKey.currentState!.save();

      String oldPassword = _oldPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmPasswordController.text;

      // print('Pass: $oldPassword $newPassword $confirmPassword');

      final webLoginProvider =
          Provider.of<WebLoginProvider>(context, listen: false);

      try {
        await webLoginProvider.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contraseña actualizada con éxito. Iniciar sesión'),
            backgroundColor: Colors.green[400],
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
        );
      } catch (e) {
        print('Error Ui WebLogin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final webLoginProvider =
        Provider.of<WebLoginProvider>(context, listen: true);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Cambiar contraseña'),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // TextFormField(
                    //   controller: _oldPasswordController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Contraseña temporal',
                    //     border: OutlineInputBorder(),
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         _obscureTextOld ? Icons.visibility_off : Icons.visibility,
                    //       ),
                    //       onPressed: _toggleOldPasswordVisibility,
                    //     ),
                    //   ),
                    //   obscureText: _obscureTextOld,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Por favor ingresa la contraseña temporal';
                    //     }
                    //     return null;
                    //   },
                    //   // onSaved: (value) {
                    //   //   _oldPassword = value!;
                    //   // },
                    // ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Nueva contraseña',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextNew
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _toggleNewPasswordVisibility,
                        ),
                      ),
                      obscureText: _obscureTextNew,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una nueva contraseña';
                        }
                        if (value.length < 2) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   print('-- Value $value');
                      //   _newPassword = value!;
                      // },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar nueva contraseña',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                      ),
                      obscureText: _obscureTextConfirm,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor confirma la nueva contraseña';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    MyButtonConfirm(
                      onTap: () => _changePassword(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /**
         * Bloque de carga
         */
        if (webLoginProvider.isLoading)
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
