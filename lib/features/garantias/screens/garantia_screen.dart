// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:bancamovil/core/models/garantia.dart';
import 'package:bancamovil/features/garantias/providers/garantia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GarantiaScreen extends StatefulWidget {
  const GarantiaScreen({super.key});

  @override
  State<GarantiaScreen> createState() => _GarantiaScreenState();
}

class _GarantiaScreenState extends State<GarantiaScreen> {
  @override
  void initState() {
    super.initState();
    // Llama a getGarantias cuando el widget se inicializa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GarantiaProvider>(context, listen: false).getGarantias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Garantías"),
        centerTitle: true,
      ),
      body: Consumer<GarantiaProvider>(
        builder: (context, garantiasProvider, child) {
          List<Garantia> garantias = garantiasProvider.garantias;

          if (garantias.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  Icon(
                    Icons.ballot,
                    size: 80.0,
                    color: Colors.pink[400],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'No se tiene garantías registradas',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Si hay garantías, muestra la lista
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: garantias.length,
            itemBuilder: (context, index) {
              final garantia = garantias[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👉 Fila con el nombre del garante (arriba)
                      Text(
                        "Garante: ${garantia.apeSocio} ${garantia.nomSocio}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 👉 Row con la info a la izquierda y el tipo a la derecha
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Columna izquierda con toda la info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InfoRow(
                                  label: "Capital",
                                  value:
                                      "\$${garantia.valCapital.toStringAsFixed(2)}",
                                  alignRight:
                                      false, // 👈 siempre pegado a la izquierda
                                ),
                                InfoRow(
                                  label: "Saldo pendiente",
                                  value:
                                      "\$${garantia.cfValSaldoPendiente.toStringAsFixed(2)}",
                                  alignRight: false,
                                ),
                                InfoRow(
                                  label: "Estado",
                                  value: garantia.numDiasMora == 0
                                      ? 'AL DÍA'
                                      : 'EN MORA',
                                  alignRight: false,
                                ),
                              ],
                            ),
                          ),

                          // Texto a la derecha en el centro
                          Container(
                            margin: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              garantia.cfTipo == "R" ? "Recibida" : "Concedidas",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: garantia.cfTipo == "R"
                                    ? Colors.green
                                    : Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool alignRight;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.alignRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: alignRight ? TextAlign.right : TextAlign.left,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
