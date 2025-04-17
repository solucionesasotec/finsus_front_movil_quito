// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bancamovil/core/models/bank_account.dart';
import 'package:bancamovil/features/deposite_data/providers/bank_account_provider.dart';
import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositeDataScreen extends StatefulWidget {
  const DepositeDataScreen({super.key});

  @override
  State<DepositeDataScreen> createState() => _DepositeDataScreenState();
}

class _DepositeDataScreenState extends State<DepositeDataScreen> {
  @override
  void initState(){
    super.initState();
    // Llama a getBankAccounts cuando el widget se inicializa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BankAccountProvider>(context, listen: false).getBankAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final empresa = authProvider.company?.nomAbreviado ?? "No definido";
    final ruc = (authProvider.company?.numRuc.toString() ?? "No definido");
    // .isNotEmpty
    // ? "${authProvider.company?.numRuc.toString() ?? "No definido"}"
    // : "No definido";

    return Scaffold(
      appBar: AppBar(
        title: Text('Datos para depósitos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            _listCuentas(),


            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                color: Colors.pink[300],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Círculo amarillo
                      Container(
                        width: 30, // Puedes ajustar el tamaño aquí
                        height: 30, // También ajustar aquí
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                          width: 16), // Espacio entre el círculo y el texto

                      // Texto
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              empresa,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(
                                height: 8), // Separación entre líneas de texto
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'RUC: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text:
                                        ruc, // Asegúrate de que 'ruc' es una cadena de texto
                                  ),
                                ],
                              ),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _listCuentas extends StatefulWidget {
  const _listCuentas({super.key});

  @override
  State<_listCuentas> createState() => _listCuentasState();
}

class _listCuentasState extends State<_listCuentas> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BankAccountProvider>(
      builder: (context, bankAccountProvider, child) {
        List<BankAccount> bankAccounts = bankAccountProvider.cuentasBanco;

        return ListView.builder(
          shrinkWrap: true, // Para que no ocupe todo el espacio disponible
          physics: NeverScrollableScrollPhysics(), // Evita conflictos de scroll en ListView anidado
          itemCount: bankAccounts.length,
          itemBuilder: (context, index) {
            final account = bankAccounts[index];

            return Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.id.nomBanco, // Mostrar el nombre del banco dinámicamente
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Cuenta: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(text: account.codTipoCuenta == 'C' ? 'Corriente' : 'Ahorros') // Tipo de cuenta dinámico
                              ],
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'N° de Cuenta: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(text: account.id.codCuenta), // Número de cuenta dinámico
                              ],
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
