// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomeServices extends StatelessWidget {
  
  final List<Map<String, dynamic>> servicios = [
    // {'icono': Icons.calculate, 'titulo': 'Simuladores'},
    // {'icono': Icons.send, 'titulo': 'Transferencias'},
    {'icono': Icons.price_check_outlined, 'titulo': 'Solicitudes'},
    {'icono': Icons.upload_file, 'titulo': 'Carga Compr.'},
    // {'icono': Icons.person, 'titulo': 'Apertura Cta'},
    // {'icono': Icons.edit_document, 'titulo': 'Datos de socio'},
    {'icono': Icons.edit_document, 'titulo': 'Datos para depósito'},
    {'icono': Icons.assignment_turned_in, 'titulo': 'Garantias'},

    // {'icono': Icons.edit_document, 'titulo': 'Test'}, // Screen Test
  ];

  HomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: servicios.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Número de elementos por fila
        mainAxisSpacing: 10.0, // Espaciado vertical entre los elementos
        crossAxisSpacing: 10.0, // Espaciado horizontal entre los elementos
      ),
      itemBuilder: (context, index) {
        final servicio = servicios[index];
        return GestureDetector(
          onTap: () {
            // Acción al presionar el botón
            print('Servicio ${servicio['titulo']} presionado');
            if (servicio['titulo'] == "Simuladores") {
              Navigator.pushNamed(context, '/simulators');
            }
            if (servicio['titulo'] == 'Solicitudes') {
              Navigator.pushNamed(context, '/solicitudcredito');
            }
            if (servicio['titulo'] == "Apertura Cta") {
              // Navigator.pushNamed(context, '/apertura');
              Navigator.pushNamed(context, '/maintenance');
            }
            if (servicio['titulo'] == "Carga Compr.") {
              Navigator.pushNamed(context, '/savereceipt');
              // Navigator.pushNamed(context, '/maintenance');
            }
            if (servicio['titulo'] == "Datos para depósito") {
              Navigator.pushNamed(context, '/depositedata');
            }
            if (servicio['titulo'] == "Garantias") {
              Navigator.pushNamed(context, '/garantias');
            }

            if (servicio['titulo'] == "Test") {
              Navigator.pushNamed(context, '/test');
            }
            
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(servicio['icono'], size: 30, color: Colors.pink[600]),
                  SizedBox(height: 8.0),
                  Text(servicio['titulo'],
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
