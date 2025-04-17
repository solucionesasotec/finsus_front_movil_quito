// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bancamovil/core/utils/constants.dart';

class AppBarContent extends StatelessWidget {
  final String numberWhatsapp = '${numEmpresa}';
  final String messageWhatsapp = '${msgEmpresa}';

  final int selectedIndex1;

  const AppBarContent({super.key, required this.selectedIndex1});

  // Nombres en barra de app
  static const List<String> _appBarTitles = <String>[
    'Home',
    // 'Productos',
    'Perfil'
  ];

  AppBar _buildAppBar(BuildContext context) {
    if (selectedIndex1 == 0) {
      return AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('lib/images/logo_finsus.png', width: 150),
            IconButton(
              color: Color(0xFF25D366), 
              icon: FaIcon(FontAwesomeIcons.whatsapp),
              onPressed: () => _openWhatsApp(context, numberWhatsapp, messageWhatsapp),
            ),
          ],
        ),
      );
    } else {
      return AppBar(
        title: Center(
          child: Text(_appBarTitles[selectedIndex1]),
        ),
        automaticallyImplyLeading:
            false, // Quita el espacio reservado para el botón "back"
      );
    }
  }

  void _openWhatsApp(BuildContext context, String phone, String text) async {
    final whatsappUrl =
        "https://wa.me/$phone?text=${Uri.encodeComponent(text)}";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      final fallbackUrl =
          "https://api.whatsapp.com/send?phone=$phone&text=${Uri.encodeComponent(text)}";
      await launchUrl(Uri.parse(fallbackUrl),
          mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppBar(context);
  }
}
