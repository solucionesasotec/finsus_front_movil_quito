// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:bancamovil/core/models/user.dart';
import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:bancamovil/features/login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  // Datos del usuario (pueden venir de un servicio)
  // final Map<String, dynamic> user = {
  //   "name": "MERA CARDOSO ANA LUCIA",
  //   "email": "mera.cardoso@gmail.com",
  //   "phone": "0967586408",
  //   "address": "Centro histórico",
  // };

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<AuthProvider>(context, listen: false);
    // sessionProvider.setContext(context);
    User? user = sessionProvider.user;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Mostrar datos del usuario
          Text('${user!.apeSocio} ${user.nomSocio} ',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('Email: ${user.dirCorreo}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('Celular: ${user.telCelular}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),

          // Botón de cerrar sesión
          Spacer(), // Empuja el botón al final de la pantalla
          GestureDetector(
            onTap: () => {
              _showLogoutDialog(context, sessionProvider),
            },
            child: Container(
              padding: EdgeInsets.all(16),
              // margin: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          // Center(
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       _showLogoutDialog(
          //           context, sessionProvider); // Muestra el diálogo para confirmar el cierre de sesión
          //     },
          //     icon: Icon(Icons.logout),
          //     label: Text('Cerrar Sesión'),
          //     style: ElevatedButton.styleFrom(
          //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Mostrar un diálogo de confirmación antes de cerrar sesión
  void _showLogoutDialog(BuildContext context, AuthProvider sessionProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              //Add await
              await sessionProvider.logout(context);
              // Navigator.of(context).pushReplacementNamed('/login');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) =>
                    false, // Elimina todas las rutas anteriores
              );
            },
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
