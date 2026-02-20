// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bancamovil/core/models/credit.dart';
import 'package:bancamovil/core/models/credit_table.dart';
import 'package:bancamovil/features/products/providers/credit_table_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditDetailsScreen extends StatefulWidget {
  const CreditDetailsScreen({super.key});

  @override
  State<CreditDetailsScreen> createState() => _CreditDetailsScreenState();
}

class _CreditDetailsScreenState extends State<CreditDetailsScreen> {
  late String _numCuenta;

  double _saldoAtrasado = 0.00;
  int _numCuotasPendientes = 0;

  @override
  void initState() {
    super.initState();

    // Detalle de creditos, para tener el num de cuotas 4/80:
    // creditTableProvider.creditTable
    /*
    Continuar
    */

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreditTableProvider>(context, listen: false)
          .getCreditTable('5', _numCuenta);

      // List<CreditTable> credTable =
      //     Provider.of<CreditTableProvider>(context, listen: false).creditTable;
      //     double num = 1.00;
      // for (var i = 0; i < credTable.length; i++) {
      //   // _saldoAtrasado += credTable[i].valSaldoMora;
      //   _saldoAtrasado += num;
      // }
      // for (var i = 0; i < credTable.length; i++) {
      //   if (credTable[i].estado == 'Pagado') {
      //     _numCuotasPendientes++;
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Credit credit = ModalRoute.of(context)!.settings.arguments as Credit;
    setState(() {
      _numCuenta = credit.cod_cuenta.toString();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Préstamo'),
        centerTitle: true,
      ),
      body: Consumer<CreditTableProvider>(
        builder: (context, creditTableProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heder detalle del Crédito
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            credit.nom_destino,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text('Crédito No: ${credit.cod_cuenta}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Capital: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        '\$${credit.valCapital.toStringAsFixed(2)}'),
                              ],
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Saldo Pendiente: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        '\$${credit.cfValSaldo.toStringAsFixed(2)}'),
                              ],
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Saldo Atrasado: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        '\$${creditTableProvider.saldoPendiente.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        color: creditTableProvider
                                                    .saldoPendiente ==
                                                0
                                            ? Colors.green
                                            : Colors.red)),
                              ],
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Días de Mora: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        '${credit.numDiasMora.toStringAsFixed(0)} ${credit.numDiasMora == 1 ? 'dia' : 'dias'}',
                                    style: TextStyle(
                                        color: credit.numDiasMora == 0
                                            ? Colors.green
                                            : Colors.red)),
                              ],
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Fecha Emisión: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: credit.fecPrestamo),
                              ],
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Fecha Vencimiento: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: credit.fecVencimiento),
                              ],
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Sección de Progreso de Pago
                Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Progreso de Pago',
                        //   style: TextStyle(
                        //       fontSize: 18, fontWeight: FontWeight.bold),
                        // ),
                        // SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // 'Pagado: ${(100 - ((credit.cfValSaldo * 100) / credit.valCapital)).toStringAsFixed(0)}%',
                              'Progreso de Pago',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              // 'Pendiente: ${((credit.cfValSaldo * 100) / credit.valCapital).toStringAsFixed(0)}%',
                              '${creditTableProvider.cuotasPagadas}/${credit.numCuotas.toStringAsFixed(0)} Cuotas',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: ((creditTableProvider.cuotasPagadas * 100) /
                                  credit.numCuotas) /
                              100,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),

                // Sección de Historial de Pagos
                Text(
                  'Historial de Pagos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: creditTableProvider.creditTable.length,
                    itemBuilder: (context, index) {
                    print('NUMERO DE CUOTAS TOTALES: ${creditTableProvider.creditTable.length}');
                      final CreditTable creditDetail =
                          creditTableProvider.creditTable[index];

                      String estado = creditDetail.estado;
                      String numeroCuota =
                          'N° ${creditDetail.numCuota.toStringAsFixed(0)}';

                      var cuota = creditDetail.valSaldoCapital +
                          double.parse(
                              creditDetail.valSaldoInteres.toStringAsFixed(2)) +
                          double.parse(
                              creditDetail.valSaldoMora.toStringAsFixed(2)) +
                          creditDetail.seguro;

                      // Definir el color dependiendo del estado
                      Color estadoColor;
                      if (estado == "Pagado") {
                        estadoColor = Colors.green;
                      } else if (estado == "Vigente") {
                        // Solo a cuota vigente se suma valInteres y NO Val saldo
                        cuota = creditDetail.valSaldoCapital +
                            creditDetail.valInteres +
                            creditDetail.valSaldoMora +
                            creditDetail.seguro;

                        estadoColor = Colors.blue;
                      } else {
                        estadoColor = Colors.red; // Para Vencido
                      }

                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                              'Fecha Pago: ${creditDetail.fecVencimiento}'),
                          // subtitle: Text('$numeroCuota\nCuota: \$${(cuota).toStringAsFixed(2)}'),
                          subtitle: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Cuota ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: '$numeroCuota\n',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'Cuota: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: '\$${(cuota).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight
                                          .bold), // Negrita solo para el valor
                                ),
                              ],
                            ),
                          ),

                          trailing: Text(
                            estado, // Mostrar el estado
                            style: TextStyle(
                                color:
                                    estadoColor, // Cambiar el color según el estado
                                fontWeight: FontWeight
                                    .bold, // Poner el estado en negrita
                                fontSize: 13.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
