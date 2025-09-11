// ignore_for_file: prefer_final_fields, prefer_const_constructors, use_build_context_synchronously, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/utils/constants.dart';
import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.login(
        _usernameController.text,
        _passwordController.text,
      );
      if (!mounted) return;

      // Si esta autenticado ingresa
      if (authProvider.isAuthenticated) {
        // Si es Empresa Valida ingresa
        final company = authProvider.company;
        if (company != null) {
          if (!company.nomEmpresa.contains(appEmpresa)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Alerta: Empresa no válida para la Banca Móvil'),
                backgroundColor: Colors.red[400],
              ),
            );
            return;
          }
        }
        Navigator.of(context).pushReplacementNamed('/home');
        return;
      }
      // Si es usuario nuevo
      if (authProvider.isNewUser) {
        Navigator.of(context).pushReplacementNamed('/updatepassword');
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red[400],
        ),
      );
    } catch (e) {
      print('Error inicio fallido: ${e}');
    }
  }

  Future<void> _changePassword() async {
    Navigator.of(context).pushNamed('/recoverpassword');
    print("Navegando a recuperar contraseña");
    return;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const SizedBox(height: 150),
                    Image.asset(
                      'lib/images/logo_finsus.png',
                      height: 100.0,
                    ),

                    // Welcome back
                    const SizedBox(height: 50),
                    Text(
                      'Bienvenido a tu Banca Móvil',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _usernameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade500), //old shade400
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Ingresar usuario',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade500), //old shade400
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Ingresar contraseña',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    // Sign in button
                    const SizedBox(height: 25),

                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        padding: EdgeInsets.all(25),
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: _changePassword,
                      child: const Text(
                          "¿Has olvidado tu contraseña?" // Aquí se cambia el color
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /**
         * Bloque de carga al iniciar sesion
         */
          if (authProvider.isLoading)
            Container(
              color: Colors.black54, // Fondo semi-transparente
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.pink[400],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
