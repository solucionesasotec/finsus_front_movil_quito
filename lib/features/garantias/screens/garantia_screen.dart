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
                      InfoRow(
                        label: "Garante",
                        value: '${garantia.apeSocio} ${garantia.nomSocio}',
                      ),
                      InfoRow(
                        label: "Capital",
                        value: "\$${garantia.valCapital.toStringAsFixed(2)}",
                      ),
                      InfoRow(
                        label: "Saldo pendiente",
                        value:
                            "\$${garantia.cfValSaldoPendiente.toStringAsFixed(2)}",
                      ),
                      InfoRow(
                        label: "Estado",
                        value: garantia.numDiasMora == 0 ? 'AL DÍA' : 'EN MORA',
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

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label fijo a la izquierda
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(width: 8), // pequeño espacio entre label y value

          // Value flexible, alineado a la derecha
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right, // 👈 se mantiene a la derecha
              softWrap: true, // 👈 permite saltar de línea
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
