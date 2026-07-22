// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bancamovil/core/models/partner_account.dart';
import 'package:bancamovil/core/models/movement.dart';
import 'package:bancamovil/features/account_details/providers/movements_provider.dart';
import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  late PartnerAccount _cuenta;
  List<Movement> _movements = [];

  // Función para seleccionar fecha de inicio
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  // Función para seleccionar fecha de fin
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  //Revisar funcion
  Future<void> _fetchMovements() async {
    // Recibir los argumentos pasados - Cuenta
    // final Account cuenta = ModalRoute.of(context)!.settings.arguments as Account;
    if (_startDate != null && _endDate != null) {
      setState(() {
        // _movements = [];
        _movements = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _endDate = DateTime.now();
    _startDate = _endDate!.subtract(Duration(days: 7));

    // _fetchMovements();
    // Llamamos al servicio para obtener las transacciones al iniciar el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovementsProvider>(context, listen: false).getTransactions(
          _startDate.toString(),
          _endDate.toString(),
          _cuenta.id.codProducto.toString(),
          _cuenta.id.codCuenta.toString());
    });
  }

  void verifySession(sessionProvider) async {
    await sessionProvider.tryAutoLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<AuthProvider>(context);
    verifySession(sessionProvider);
    // Recibir los argumentos pasados - Cuenta
    final PartnerAccount cuenta =
        ModalRoute.of(context)!.settings.arguments as PartnerAccount;
    setState(() {
      _cuenta = cuenta;
    });
    // final sessionProvider = Provider.of<AuthProvider>(context);
    // sessionProvider.setContext(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Detalle de la cuenta'),
          centerTitle: true,
        ),
        body: Consumer<MovementsProvider>(
          builder: (context, transactionsProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    '${cuenta.nomProducto}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Saldo disponible', style: TextStyle(fontSize: 15)),
                  Text('\$${cuenta.valSaldo}', style: TextStyle(fontSize: 30)),
                  SizedBox(height: 8),

                  // Boton de transacciones
                  if (cuenta.id.codProducto == 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => {
                              Navigator.pushNamed(
                                context,
                                '/transactions',
                                arguments:
                                    cuenta, // Enviamos el objeto como argumento
                              ),
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.pink[400],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.send, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Tranferir dinero',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 20),
                  // Campos de selección de fechas
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            // Text('Fecha Inicio'),
                            ElevatedButton(
                              onPressed: () => _selectStartDate(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400],
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                _startDate != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(_startDate!)
                                    : 'dd/mm/aaaa',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            // Text('Fecha Fin'),
                            ElevatedButton(
                              onPressed: () => _selectEndDate(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400],
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(_endDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                  : 'dd/mm/aaaa'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () =>
                                transactionsProvider.getTransactions(
                                    _startDate.toString(),
                                    _endDate.toString(),
                                    cuenta.id.codProducto.toString(),
                                    cuenta.id.codCuenta.toString()),
                            child: Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Movimientos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Expanded(
                    child: RefreshIndicator(
                        onRefresh: () => transactionsProvider.getTransactions(
                            _startDate.toString(),
                            _endDate.toString(),
                            cuenta.id.codProducto.toString(),
                            cuenta.id.codCuenta.toString()),
                        color: Colors.pink[400],
                        // child: _movements.isEmpty
                        child: transactionsProvider.transactions.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inbox,
                                      size: 80.0,
                                      color: Colors.pink[400],
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      'No hay movimientos para las fechas seleccionadas',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount:
                                    transactionsProvider.transactions.length,
                                itemBuilder: (context, index) {
                                  final movement =
                                      transactionsProvider.transactions[index];
                                  final formattedDate = DateFormat('dd/MM/yyyy')
                                      .format(movement.fecMovimiento!);
                                  // final formattedDate = movement.fecMovimiento;
                                  final isIncome =
                                      movement.sts_d_c == 'Ingreso';
                                  final valueStyle = TextStyle(
                                      color:
                                          isIncome ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20);

                                  // Formato del valor de la transacción con 2 decimales
                                  final transactionValue =
                                      (isIncome ? '+' : '-') +
                                          NumberFormat.currency(
                                                  symbol: '\$',
                                                  decimalDigits: 2)
                                              .format(movement.valEfectivo);
                                  final saldoValue = NumberFormat.currency(
                                          symbol: '\$', decimalDigits: 2)
                                      .format(movement.valSaldo);

                                  return ListTile(
                                    // leading: Icon(
                                    //   Icons.monetization_on,
                                    //   color: isIncome
                                    //       ? Colors.green
                                    //       : Colors
                                    //           .red, // Ícono cambia según ingreso o egreso
                                    // ),
                                    title: Text(movement.nom_transaccion ??
                                        ''), // Nombre de la transacción
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Tipo: ${movement.id.cod_transaccion}'),
                                        Text('Fecha: $formattedDate'),
                                      ],
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize
                                          .min, // Para ajustar el tamaño del column al contenido
                                      children: [
                                        Text(
                                          '${transactionValue}', // Valor de la transacción
                                          style: valueStyle,
                                        ),
                                        Text(
                                          '${saldoValue}', // Saldo final después de la transacción
                                          style: const TextStyle(
                                            fontWeight: FontWeight
                                                .w500, // Estilo neutro para el saldo
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )

                        // : ListView.builder(
                        //     itemCount: transactionsProvider.transactions.length,
                        //     itemBuilder: (context, index) {
                        //       final movement =
                        //           transactionsProvider.transactions[index];
                        //       return ListTile(
                        //         leading: Icon(Icons.monetization_on),
                        //         title: Text(movement.id.cod_transaccion),
                        //         subtitle: Text('Detalle del movimiento'),
                        //         trailing: Text('\$ ${movement.valEfectivo}'),
                        //       );
                        //     },
                        //   ),
                        ),
                  ),

                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: 10, // número de movimientos
                  //     itemBuilder: (context, index) {
                  //       return ListTile(
                  //         leading: Icon(Icons.monetization_on),
                  //         title: Text('Movimiento $index'),
                  //         subtitle: Text('Detalle del movimiento'),
                  //         trailing: Text('-\$100.00'),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ));
  }
}
