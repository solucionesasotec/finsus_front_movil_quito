// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:bancamovil/features/simulators/widgets/my_button_investment_sim.dart';
import 'package:flutter/material.dart';

class InvestmentSimulatorTab extends StatefulWidget {
  const InvestmentSimulatorTab({super.key});

  @override
  State<InvestmentSimulatorTab> createState() => _InvestmentSimulatorTabState();
}

class _InvestmentSimulatorTabState extends State<InvestmentSimulatorTab> {
  final _formKeyInvestSim = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _plazoController = TextEditingController();

  String? _capital;
  String? _interes;
  String? _tea;
  String? _totPagar;
  String? _numPlazo;

  Future<void> _generate() async {
    // print('Tipo credito: ${_tipoCredito}');
    // print('Credito: ${_credito}');
    // print('Tasa: ${_tipoCredito}');
    // print('Monto: ${_montoController.text}');
    // print('Plazo: ${_plazoController.text}');

    if (_formKeyInvestSim.currentState!.validate() == true) {
      // _formKeyInvestSim.currentState?.save();
      print('--- Form Sim Inversion OK');

      double capital = double.parse(_montoController.text);
      int ncuotas = int.parse(_plazoController.text);

      var tea;
      // if (capital >= 1000 && capital < 5000) {
      //   tea = getTea(ncuotas, 0);
      // } else if (capital >= 5000 && capital < 20000) {
      //   tea = getTea(ncuotas, 1);
      // } else if (capital >= 20000 && capital < 50000) {
      //   tea = getTea(ncuotas, 2);
      // } else if (capital >= 50000 && capital <= 100000) {
      //   tea = getTea(ncuotas, 3);
      // }
      if (capital >= 1000 && capital < 5000) {
        tea = getTea(ncuotas, 0);
      } else if (capital >= 5000 && capital < 20000) {
        tea = getTea(ncuotas, 1);
      } else if (capital >= 20000 && capital < 50000) {
        tea = getTea(ncuotas, 2);
      } else if (capital >= 50000 && capital <= 100000) {
        tea = getTea(ncuotas, 3);
      }

      //calcular
      // capital *= 1;
      var x = 1 + (tea / 100);
      var y = ncuotas / 360;
      var interes;
      try {
        interes = capital * (pow(x, y) - 1);
      } catch (e) {
        interes = 0;
      }

      setState(() {
        _capital = capital.toStringAsFixed(2);
        _interes = interes.toStringAsFixed(2);
        _tea = tea.toStringAsFixed(2).toString();
        _totPagar = (capital + interes).toStringAsFixed(2).toString();
        _numPlazo = ncuotas.toString();
      });
    } else {
      print('--- Form Sim Inversion NO VALIDO');
    }
  }

  getTea(int ncuotas, int caso) {
    var teaarray = [
      // [4.00, 4.50, 5.00, 6.00, 6.50, 6.80, 7.00, 7.50],
      // [4.15, 4.60, 5.15, 6.50, 6.80, 7.30, 7.50, 8.00],
      // [4.25, 4.65, 5.30, 6.65, 7.00, 7.35, 7.80, 8.50],
      // [4.30, 4.80, 5.40, 6.80, 7.20, 7.60, 8.50, 9.00],
      [4.00, 4.50, 5.00, 6.00, 6.50, 6.80, 7.00, 7.50],
      [4.15, 4.60, 5.15, 6.50, 6.80, 7.30, 7.50, 8.00],
      [4.25, 4.65, 5.30, 6.65, 7.00, 7.35, 7.80, 8.50],
      [4.30, 4.80, 5.40, 6.80, 7.20, 7.60, 8.50, 9.00],
    ];

    //logica exclusiva de de coac smc
    // ncuotas = ncuotas*1;
    var tea = teaarray[caso][0];
    if (ncuotas > 30 && ncuotas <= 60) {
      tea = teaarray[caso][1];
    } else if (ncuotas > 60 && ncuotas <= 90) {
      tea = teaarray[caso][2];
    } else if (ncuotas > 90 && ncuotas <= 120) {
      tea = teaarray[caso][3];
    } else if (ncuotas > 120 && ncuotas <= 180) {
      tea = teaarray[caso][4];
    } else if (ncuotas > 180 && ncuotas <= 270) {
      tea = teaarray[caso][5];
    } else if (ncuotas > 270 && ncuotas <= 360) {
      tea = teaarray[caso][6];
    } else if (ncuotas > 360) {
      tea = teaarray[caso][7];
    }

    return tea;
  }

  @override
  void initState() {
    super.initState();
    _capital = '0.00';
    _numPlazo = '0';
    _interes = '0.00';
    _tea = '0.00';
    _totPagar = '0.00';
    _numPlazo = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyInvestSim,
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Text('Capital: \$$_capital', style: TextStyle(fontSize: 30)),
                  SizedBox(height: 10),
                  Text('Interés: \$$_interes', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Tasa anual: ${_tea}%', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Total a pagar: \$$_totPagar',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Días: $_numPlazo', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Monto
            TextFormField(
              controller: _montoController,
              decoration: InputDecoration(
                labelText: 'Ingresar un monto',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => {
                // Validacon del monto MAX y MIN, en funcion de Tipo/Clasif Credito
                // Aquí llamamos a la validación cuando cambia validaro.
                // _formKeyInvestSim.currentState?.validate(),
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                double? monto = double.tryParse(value);
                double? montoMin = 1000;
                double? montoMax = 100000;
                if (monto! <= 1000) {
                  return 'El monto debe ser mayor a $montoMin';
                }
                if (monto >= 10000) {
                  return 'El monto debe ser menor a $montoMax';
                }



                return null; // Validaciones locales pasaron
              },
            ),
            SizedBox(height: 15),

            // Plazo
            TextFormField(
              controller: _plazoController,
              decoration: InputDecoration(
                labelText: 'Ingresar plazo (dias)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => {
                // Validacon del monto MAX y MIN, en funcion de Tipo/Clasif Credito
                // Aquí llamamos a la validación cuando cambia validaro.
                // _formKeyInvestSim.currentState?.validate(),
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                int? plazo = int.tryParse(value);
                if (plazo! < 0) {
                  return 'El plazo debe ser mayor a 0';
                }
                return null; // Validaciones locales pasaron
              },
            ),
            SizedBox(height: 15),

            MyButtonInvestmentSim(
              onTap: () => _generate(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
