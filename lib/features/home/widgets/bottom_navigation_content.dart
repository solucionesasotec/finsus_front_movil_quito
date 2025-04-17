// ignore_for_file: slash_for_doc_comments, prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:bancamovil/features/extras/screens/maintenance_screen.dart';
import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:bancamovil/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_carousel.dart';
import 'home_services.dart';

class BottomNavigationContent extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigationContent({super.key, required this.selectedIndex});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(),

        // HomeCarousel(),
        SizedBox(
          height: 250,
          child: HomeCarousel(),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Que deseas hacer hoy?',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),

        // //Servicios V1
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          height: 265.0, // Establece una altura fija
          child: HomeServices(),
        ),
      ],
    ),

    // MaintenanceScreen(),

    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // final sessionProvider = Provider.of<AuthProvider>(context);
    // sessionProvider.setContext(context);

    return _widgetOptions.elementAt(selectedIndex);
  }
}

/**
 * Datos del Usuario usando SharedPreferences
 */
class HeaderText extends StatefulWidget {
  const HeaderText({super.key});

  @override
  State<HeaderText> createState() => _HeaderTextState();
}

class _HeaderTextState extends State<HeaderText> {

  @override
  Widget build(BuildContext context) {
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        // 'Hola, ${_user?.apeSocio ?? 'Cargando' } ${_user?.nomSocio}.',
        'Hola, ${authProvider.user?.apeSocio} ${authProvider.user?.nomSocio}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
