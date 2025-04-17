// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:bancamovil/core/models/clasif_credit.dart';
import 'package:bancamovil/features/extras/providers/clasif_credit_provider.dart';
import 'package:bancamovil/features/simulators/widgets/dropdown_credit.dart';
import 'package:bancamovil/features/simulators/widgets/dropdown_type_credit.dart';
import 'package:bancamovil/features/simulators/widgets/my_button_credit_sim.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/type_credit.dart';
import '../../extras/providers/type_credit_provider.dart';
import '../../solicitudes/providers/sgf_sol_credit_provider.dart';

class CreditSimulatorTab extends StatefulWidget {
  const CreditSimulatorTab({super.key});

  @override
  State<CreditSimulatorTab> createState() => _CreditSimulatorTabState();
}

class _CreditSimulatorTabState extends State<CreditSimulatorTab> {
  String? _typeCreditSelected;
  String? _creditSelected;

  // Variables
  final _formKeyCredSim = GlobalKey<FormState>();
  String? _tipoCredito;
  String? _credito;
  // late ClasifCredit _clasifCred;
  var _tasaInteres = TextEditingController();
  final _montoController = TextEditingController();
  final _plazoController = TextEditingController();

  String? _capital = '0.00';
  String? _interes = '0.00';
  String? _totInteresCapital = '0.00';

  List<List<dynamic>> tablaAmortizacion = [];
  var _isVisibleTable = false;

  double _valMin = 0;
  double _valMax = 0;
  double _numPlazoMin = 0;
  double _numPlazoMax = 0;

  Future<void> _generate() async {
    if (_formKeyCredSim.currentState!.validate() == true) {
      _formKeyCredSim.currentState?.save();

      print('--- Form Sim Cred OK');
      // print('Tipo credito: ${_tipoCredito}');
      // print('Credito: ${_credito}');
      // print('Tasa: ${_tipoCredito}');
      // print('Monto: ${_montoController.text}');
      // print('Plazo: ${_plazoController.text}');

      var monto = double.parse(_montoController.text);
      var plazo = int.parse(_plazoController.text);
      var tasa = double.parse(_tasaInteres.text);
      var tasaSeguro = double.parse(_tasaInteres.text);
      tablaAmortizacion = [];
      calculosTotales(monto, plazo, tasa, tasaSeguro); //Add tasa del seguro

      setState(() {
        _capital = monto.toStringAsFixed(2);
      });
    } else {
      print('--- Form Sim Cred NO VALIDO');
    }
  }

  calculosTotales(double monto, int plazo, double tasa, double tasaseguro) {
    double tasainteres = 0;
    double seguro = 0;
    double saldoAnterior0 = 0;
    double totalAmortizacion = 0;
    //this.totalAmortizacion += amortizacion;
    double totalInteres = 0;
    double totalCuota = 0;

    // var totalAmortizacion = 0;
    // var totalInteres = 0;
    // var totalCuota = 0;
    var saldoAnterior = monto * 1;

    var cuota = getCuota(monto, plazo, tasa);
    for (var i = 1; i <= plazo; i++) {
      var valorInteres = getInteres(saldoAnterior, tasa);
      var seguro = getSeguro(saldoAnterior, tasaseguro);
      var amortizacion = cuota - valorInteres;
      var tasa_int = tasa;
      var saldoActual = saldoAnterior - amortizacion;
      var totcuota = cuota;

      tablaAmortizacion.add([
        i,
        amortizacion.toStringAsFixed(2),
        tasa_int,
        valorInteres.toStringAsFixed(2),
        seguro.toStringAsFixed(2),
        totcuota.toStringAsFixed(2),
        saldoAnterior.toStringAsFixed(2)
      ]);

      // console.log(this.data)
      // print('\n--- Cuota: ${data[i]}');
      tasainteres = tasa;
      seguro += seguro;
      saldoAnterior = saldoActual;
      totalAmortizacion += amortizacion;
      //this.totalAmortizacion += amortizacion;
      totalInteres += valorInteres;
      totalCuota += cuota;
    }

    // Add totalizado amortizacion
    tablaAmortizacion.add([
      '',
      totalAmortizacion.toStringAsFixed(2),
      tasainteres,
      totalInteres.toStringAsFixed(2),
      seguro.toStringAsFixed(2),
      totalCuota.toStringAsFixed(2),
      saldoAnterior.toStringAsFixed(2)
    ]);

    setState(() {
      _interes = totalInteres.toStringAsFixed(2);
      _totInteresCapital = totalCuota.toStringAsFixed(2);
      _isVisibleTable = true;
    });

    // for (var i = 0; i < tablaAmortizacion.length; i++) {
    //   print('\n--- Data: ${tablaAmortizacion[i]}');
    // }
  }

  getCuota(double capital, int cuotas, double interes) {
    var numerador = (interes / 12) / 100;
    var denominador = 1 - pow(1 + numerador, -cuotas);
    var cuota = capital * numerador / denominador;
    return cuota;
  }

  getInteres(saldo, interes) {
    var numerador = (interes / 12) / 100;
    var intere = saldo * numerador;
    return intere;
  }

  getSeguro(saldo, interes) {
    var numerador = (saldo * interes) / 100;
    return numerador;
  }

  // void handleTypeCreditSelected(String? concept) {
  //   setState(() {
  //     _tipoCredito = concept;
  //   });
  //   // Aquí llamamos a la validación cuando se selecciona un valor.
  //   // _formKeyCredSim.currentState?.validate();
  // }

  // void handleCreditSelected(String? concept) {
  //   setState(() {
  //     _credito = concept;
  //     _clasifCred = Provider.of<ClasifCreditProvider>(context, listen: false)
  //         .getOneClasifCredit(int.parse(concept!));
  //     _tasaInteres = TextEditingController(
  //       text: _clasifCred.valTasaMin.toString(),
  //     );
  //   });

  //   // Aquí llamamos a la validación cuando se selecciona un valor.
  //   // _formKeyCredSim.currentState?.validate();
  // }

  @override
  void initState() {
    super.initState();

    // usa provider 1 sola vez, pero si hay cambios en la base, se regresa <- screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TypeCreditProvider>(context, listen: false).getTypeCredits();
    });
  }

  @override
  Widget build(BuildContext context) {
    var clasifCreditProvider = Provider.of<ClasifCreditProvider>(context);

    var solCreditoProvider = Provider.of<SgfSolCreditoProvider>(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKeyCredSim,
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text('Capital: \$$_capital',
                          style: TextStyle(fontSize: 30)),
                      SizedBox(height: 10),
                      Text('Interés: \$$_interes',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Total interés + capital: \$$_totInteresCapital',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                if (_isVisibleTable)
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text('Ver tabla de amortización'),
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(label: Text('N°')),
                                  DataColumn(label: Text('Amortización')),
                                  DataColumn(label: Text('Tasa %')),
                                  DataColumn(label: Text('Interés')),
                                  DataColumn(label: Text('Seguro')),
                                  DataColumn(label: Text('Cuota')),
                                  DataColumn(label: Text('Saldo')),
                                ],
                                rows: tablaAmortizacion
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  List<dynamic> fila = entry.value;
                                  bool esUltimaFila =
                                      index == tablaAmortizacion.length - 1;

                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                        fila[0].toString(),
                                        style:
                                            TextStyle(color: Colors.pink[300]),
                                      )),
                                      DataCell(Text(
                                        fila[1].toString(),
                                        style: esUltimaFila
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink[300])
                                            : null,
                                      )),
                                      DataCell(Text(
                                        fila[2].toString(),
                                        style: esUltimaFila
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink[300])
                                            : null,
                                      )),
                                      DataCell(Text(
                                        fila[3].toString(),
                                        style: esUltimaFila
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink[300])
                                            : null,
                                      )),
                                      DataCell(Text(
                                        fila[4].toString(),
                                        style: esUltimaFila
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink[300])
                                            : null,
                                      )),
                                      DataCell(Text(
                                        fila[5].toString(),
                                        style: esUltimaFila
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink[300])
                                            : null,
                                      )),
                                      DataCell(Text(
                                        fila[6].toString(),
                                        style: esUltimaFila
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink[300])
                                            : null,
                                      )),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                // Opciones tipo de creditos
                // Padding(
                //   padding: const EdgeInsets.only(top: 16.0),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Expanded(
                //           child: DropdownTypeCredit(
                //         onTypeCreditSelected: handleTypeCreditSelected,
                //       ))
                //     ],
                //   ),
                // ),

                // // Opciones creditos
                // Padding(
                //   padding: const EdgeInsets.only(top: 16.0),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Expanded(
                //           child: DropdownCredit(
                //         onCreditSelected: handleCreditSelected,
                //         codTypeCredit: _tipoCredito,
                //       ))
                //     ],
                //   ),
                // ),
                // SizedBox(height: 15),
                Consumer<TypeCreditProvider>(
                  builder: (context, typeCreditProvider, child) {
                    List<TypeCredit> tiposCredito =
                        typeCreditProvider.typeCredits;

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tipo de crédito',
                        border: OutlineInputBorder(), // Aplica el borde
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 18.0),
                      ),
                      // hint: Text("Tipo de cuenta de beneficiario"),
                      // value: selectedValue, // Valor seleccionado actualmente

                      items: tiposCredito.map((TypeCredit item) {
                        return DropdownMenuItem<String>(
                          value: item.codTipoCredito.toString(),
                          child: Text(
                            item.nomTipoCredito,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),

                      selectedItemBuilder: (BuildContext context) {
                        return tiposCredito.map((TypeCredit item) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              item.nomTipoCredito,
                              overflow: TextOverflow.ellipsis,
                              // style: TextStyle(fontSize: 16.0),
                            ),
                          );
                        }).toList();
                      },

                      onChanged: (String? newValue) {
                        setState(() {
                          _typeCreditSelected = newValue;
                          // _creditSelected = null;
                          clasifCreditProvider
                              .getClasifCredits(int.parse(newValue!));
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un tipo de crédito';
                        }
                        return null;
                      },
                    );
                  },
                ),

                SizedBox(height: 15),

                // Tipo de credito
                Consumer<ClasifCreditProvider>(
                  builder: (context, clasifCreditProvider, child) {
                    List<ClasifCredit> clasCred;
                    if (_typeCreditSelected == null) {
                      clasCred = clasifCreditProvider.clasifCredits;
                    } else {
                      _creditSelected = null;
                      clasCred = [];
                    }

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Crédito',
                        border: OutlineInputBorder(), // Aplica el borde
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 18.0),
                      ),
                      items: clasifCreditProvider.clasifCredits
                          .map((ClasifCredit item) {
                        return DropdownMenuItem<String>(
                          // value: item.codClasifCredito.toString(),
                          value: item.codClasifCredito.toString(),
                          child: Text(item.nomClasifCredito),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return clasifCreditProvider.clasifCredits
                            .map((ClasifCredit item) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              item.nomClasifCredito,
                              overflow: TextOverflow.ellipsis,
                              // style: TextStyle(fontSize: 16.0),
                            ),
                          );
                        }).toList();
                      },
                      onSaved: (newValue) {
                        _creditSelected = newValue;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          _creditSelected = newValue;

                          ClasifCredit _clasifCred =
                              Provider.of<ClasifCreditProvider>(context,
                                      listen: false)
                                  .getOneClasifCredit(int.parse(newValue!));
                          _tasaInteres = TextEditingController(
                            text: _clasifCred.valTasaMin.toString(),
                          );

                          // Set Datos
                          // valMin = _clasifCred.valCapitalMin;
                          // valMax = _clasifCred.valCapitalMax;
                          setState(() {
                            _valMin = _clasifCred.valCapitalMin;
                            _valMax = _clasifCred.valCapitalMax;
                            _numPlazoMin = _clasifCred.numPlazoMin;
                            _numPlazoMax = _clasifCred.numPlazoMax;
                          });
                        });
                        // widget.onCreditSelected(newValue);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un crédito';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 15),

                // tasa
                // TextFormField(
                //   controller: _tasaInteres,
                //   decoration: InputDecoration(
                //     labelText: 'Tasa interes %',
                //     border: OutlineInputBorder(),
                //   ),
                //   keyboardType: TextInputType.number,
                //   enabled: false,
                // ),
                // SizedBox(height: 15),

                TextFormField(
                  controller: _montoController,
                  decoration: InputDecoration(
                    labelText: 'Ingresar un monto',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => {
                    // Validacon del monto MAX y MIN, en funcion de Tipo/Clasif Credito
                    // setState(() {
                    //   _formKeyCredSim.currentState?.validate();
                    // })
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    double? valMonto = double.tryParse(value);

                    double valMinimo = _valMin;
                    double valMaximo = _valMax;

                    if (valMonto! < valMinimo) {
                      return 'El monto debe ser mayor a $valMinimo';
                    }
                    if (valMonto > valMaximo) {
                      return 'El monto debe ser menor a $valMaximo';
                    }
                    return null;
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Campo obligatorio';
                  //   }
                  //   double? monto = double.tryParse(value);

                  //   double montoMinimo = _clasifCred.valCapitalMin;
                  //   double montoMaximo = _clasifCred.valCapitalMax;

                  //   if (monto! < montoMinimo) {
                  //     return 'El monto debe ser mayor a $montoMinimo';
                  //   }

                  //   if (monto > montoMaximo) {
                  //     return 'El monto debe ser menor a $montoMaximo';
                  //   }
                  //   return null; // Validaciones locales pasaron
                  // },
                ),
                SizedBox(height: 15),

                // Plazo
                TextFormField(
                  controller: _plazoController,
                  decoration: InputDecoration(
                    labelText: 'Ingresar plazo (meses)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => {
                    // Validacon del monto MAX y MIN, en funcion de Tipo/Clasif Credito
                    // Aquí llamamos a la validación cuando cambia validaro.
                    // _formKeyCredSim.currentState?.validate(),
                  },
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio';
                      }
                      int? valPlazo = int.tryParse(value);

                      double valMinimo = _numPlazoMin;
                      double valMaximo = _numPlazoMax;

                      if (valPlazo! < valMinimo) {
                        return 'El plazo debe ser mayor a $valMinimo';
                      }
                      if (valPlazo > valMaximo) {
                        return 'El plazo debe ser menor a $valMaximo';
                      }
                      return null;
                    },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Campo obligatorio';
                  //   }
                  //   double? numPlazo = double.tryParse(value);

                  //   double plazoMinimo = _clasifCred.numPlazoMin;
                  //   double plazoMaximo = _clasifCred.numPlazoMax;

                  //   if (numPlazo! < plazoMinimo) {
                  //     return 'El plazo debe ser mayor a $plazoMinimo';
                  //   }
                  //   if (numPlazo > plazoMaximo) {
                  //     return 'El plazo debe ser menor a $plazoMaximo';
                  //   }
                  //   return null; // Validaciones locales pasaron
                  // },
                ),
                SizedBox(height: 15),

                MyButtonCreditSim(
                  onTap: () => _generate(),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),

        /**
         * Bloque de carga
         */
        // if (smsProvider.isLoading)
        //   Container(
        //     color: Colors.black54, // Fondo semi-transparente
        //     child: Center(
        //       child: CircularProgressIndicator(
        //         color: Colors.pink[400],
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
