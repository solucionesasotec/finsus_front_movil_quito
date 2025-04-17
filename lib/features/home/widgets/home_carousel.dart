// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:bancamovil/core/models/partner_account.dart';
import 'package:bancamovil/core/models/credit.dart';
import 'package:bancamovil/core/models/investments.dart';
import 'package:bancamovil/features/products/providers/partner_accounts_provider.dart';
import 'package:bancamovil/features/products/providers/credits_provider.dart';
import 'package:bancamovil/features/products/providers/investments_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  String selectedType = 'Cuentas';

  List<PartnerAccount> accounts = [];
  List<Credit> credits = [];
  List<Investment> investments = [];

  List<dynamic> get filteredServices {
    switch (selectedType) {
      case 'Cuentas':
        return Provider.of<PartnerAccountsProvider>(context).accounts;
      // return accounts;
      case 'Préstamos':
        return Provider.of<CreditsProvider>(context).credits;
      // return credits;
      case 'Inversiones':
        return Provider.of<InvestmentsProvider>(context).investments;
      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    accounts = [];
    credits = [];
    investments = [];

    // Cargar las cuentas al inicializar el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PartnerAccountsProvider>(context, listen: false)
          .getAccounts();
      Provider.of<CreditsProvider>(context, listen: false).getCredits();
      Provider.of<InvestmentsProvider>(context, listen: false).getInvestments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sección superior con contenedores
        SizedBox(
          height: 50,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            children: [
              buildContainer('Cuentas'),
              buildContainer('Préstamos'),
              buildContainer('Inversiones'),
            ],
          ),
        ),

        // Sección inferior con la lista de tarjetas según la selección
        Expanded(
          child: buidList(),
        ),
      ],
    );
  }

  // Crea un widget para cada contenedor - Tipos (Cuentas, Prestamos, Inversioes, etc)
  GestureDetector buildContainer(String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedType == type ? Colors.pink[400] : Colors.black87,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget buidList() {
    if (filteredServices.isEmpty) {
      String msg;
      switch (selectedType) {
        case 'Cuentas':
          msg = "Cuentas";
          break;
        case 'Préstamos':
          msg = "Préstamos";
          break;
        case 'Inversiones':
          msg = "Inversiones";
          break;
        default:
          msg = "Otros";
      }
      return ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centrar verticalmente
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No tiene ${msg} actualmente",
                    // "${msg} en Mantenimiento",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // CUENTAS DE AHORRO
    switch (selectedType) {
      case 'Cuentas':
        return PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            final cuenta = filteredServices[index];
            return GestureDetector(
              onTap: () {
                final cuentaSeleccionada = cuenta;
                Navigator.pushNamed(
                  context,
                  '/saving/details',
                  arguments: cuentaSeleccionada,
                );
              },
              child: Card(
                elevation: 4,
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          cuenta.nomProducto,
                          style: TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Saldo Disponible', style: TextStyle(fontSize: 12)),
                      Text(
                        '\$ ${cuenta.valSaldo}',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nro. Cuenta: ${cuenta.id.codCuenta}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

      // PRESTAMOS / CREDITOS
      case 'Préstamos':
        return PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          // padding: const EdgeInsets.symmetric(horizontal: 16.0),
          scrollDirection: Axis.horizontal,
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            final Credit credito = filteredServices[index];
            return GestureDetector(
              onTap: () {
                // print('Cuenta: ${credito.cod_cuenta}');
                Navigator.pushNamed(
                  context,
                  '/credit/details',
                  arguments: credito, // Enviamos el objeto como argumento
                );
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          credito.nom_destino,
                          style: TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Saldo Pendiente', style: TextStyle(fontSize: 12)),
                      Text('\$ ${credito.cfValSaldo}',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold,
                              color: credito.numDiasMora>0 ?Colors.red:Colors.black)),
                      Text('Fecha préstamo: ${credito.fecPrestamo}',
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                      Text('Fecha vencimiento: ${credito.fecVencimiento}',
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            );
          },
        );

      case 'Inversiones':
        return PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          // padding: const EdgeInsets.symmetric(horizontal: 16.0),
          scrollDirection: Axis.horizontal,
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            final Investment inversion = filteredServices[index];
            return GestureDetector(
              onTap: () {
                print('Inversion: ${inversion.id.codCuenta}');
                // Navigator.pushNamed(
                //   context,
                //   '/credit/details',
                //   arguments: inversion, // Enviamos el objeto como argumento
                // );
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          inversion.nomProducto,
                          style: TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Monto', style: TextStyle(fontSize: 12)),
                      Text('\$ ${inversion.valDeposito}',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      // Text('Nro. Plazo: ${inversion.numPlazo}',
                      //     style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('Rendimiento: ${inversion.valInteres}',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),

                      // Text('Fecha Depósito: ${inversion.fecVencimiento}',
                      //     style: TextStyle(fontSize: 13, color: Colors.grey)),
                      Text('Vence: ${inversion.fecVencimiento}',
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      default:
        return ListView();
    }
  }
}
