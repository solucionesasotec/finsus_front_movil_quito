// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:bancamovil/core/models/clasif_credit.dart';
import 'package:bancamovil/core/models/company.dart';
import 'package:bancamovil/core/models/partner_account.dart';
import 'package:bancamovil/core/models/type_credit.dart';
import 'package:bancamovil/core/models/user.dart';
import 'package:bancamovil/core/services/pdf_service.dart';
import 'package:bancamovil/features/extras/providers/clasif_credit_provider.dart';
import 'package:bancamovil/features/extras/providers/type_credit_provider.dart';
import 'package:bancamovil/features/home/screens/home_screen.dart';
import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:bancamovil/features/login/screens/login_screen.dart';
import 'package:bancamovil/features/products/providers/accounts_provider.dart';
import 'package:bancamovil/features/products/providers/partner_accounts_provider.dart';
import 'package:bancamovil/features/solicitudes/providers/sgf_sol_credit_provider.dart';
import 'package:bancamovil/features/solicitudes/widgets/my_button_send.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditSolScreen extends StatefulWidget {
  const CreditSolScreen({super.key});

  @override
  State<CreditSolScreen> createState() => _CreditSolScreenState();
}

class _CreditSolScreenState extends State<CreditSolScreen> {
  final _formKeySaveReceipt = GlobalKey<FormState>();

  String? _typeCreditSelected;
  String? _creditSelected;
  List<ClasifCredit> _clasifCreditos = [];
  var _tasaInteres = TextEditingController();

  final _montoController = TextEditingController();
  final _numCuotasController = TextEditingController();

  double _valMin = 0;
  double _valMax = 0;
  double _numPlazoMin = 0;
  double _numPlazoMax = 0;

  Future<void> _save() async {
    if (_formKeySaveReceipt.currentState!.validate() == true) {
      _formKeySaveReceipt.currentState?.save();

      print('--- Form Save Receipt OK');

      User? user = Provider.of<AuthProvider>(context, listen: false).user;
      List<PartnerAccount> accounts =
          Provider.of<PartnerAccountsProvider>(context, listen: false).accounts;
      PartnerAccount ahorroVista =
          accounts.where((account) => account.id.codProducto == 1).first;

      var solCreditoProvider =
          Provider.of<SgfSolCreditoProvider>(context, listen: false);

      var userProvider = Provider.of<AuthProvider>(context, listen: false);
      User _user = userProvider.user!;
      Company _company = userProvider.company!;

      try {
        print('Cuenta Ahorros: ${ahorroVista.id.codCuenta}');
        print('Tipo Credit: $_typeCreditSelected');
        print('Credit: $_creditSelected');
        print('Tasa: ${_tasaInteres.text}');
        print('Monto: ${_montoController.text}');
        print('Num CUotas: ${_numCuotasController.text}');

        String capital = _montoController.text;
        String tasa = _tasaInteres.text;
        String cuotas = _numCuotasController.text;

        DateTime now = DateTime.now();
        String strDateNow =
            "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}";
        int? xDias = int.tryParse(cuotas);
        DateTime futureDate = now.add(Duration(days: xDias! * 30));
        String strFutureDate =
            "${futureDate.day}-${futureDate.month}-${futureDate.year}";

        int plazo = xDias * 30;

        await solCreditoProvider.generateSolCredit(
            ahorroVista.id.codCuenta.toString(),
            // '360',
            capital,
            tasa,
            '0',
            cuotas,
            strDateNow,
            strFutureDate,
            plazo.toString(),
            strFutureDate,
            _typeCreditSelected!,
            _typeCreditSelected!);

        if (solCreditoProvider.solCredit != null) {
          print('Solicitud creada');

          PdfService().generateCreditRequestForm(
            socio: _user,
            empresa: _company,
            montoCredito: double.parse(capital),
            plazoMeses: int.parse(cuotas),
          );

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Text('Completado'),
              content: Text(
                  'Dentro de 24 horas un Ejecutivo de Crédito se comunicará con usted.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Navigator.of(ctx).pushReplacementNamed('/login');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) =>
                          false, // Elimina todas las rutas anteriores
                    );
                  },
                  child: Text('Aceptar'),
                ),
              ],
            ),
          );
        } else {
          print('Solicitud NO creada');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Aviso: No es posible solicitar. Socio con crédito vigente'),
              backgroundColor: Colors.blue[400],
            ),
          );
        }
      } catch (e) {
        print('Error en solicitar credito');
      }
    } else {
      print('--- Form Save Receipt NO VALIDO');
    }
  }

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
    // var typeCreditProvider =
    //     Provider.of<TypeCreditProvider>(context, listen: false);
    // List<TypeCredit> tiposCredito = typeCreditProvider.typeCredits;

    var clasifCreditProvider = Provider.of<ClasifCreditProvider>(context);

    var solCreditoProvider = Provider.of<SgfSolCreditoProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Solicitud de Crédito'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKeySaveReceipt,
              child: ListView(
                children: [
                  // Select Tipo de credito

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
                      labelText: 'Monto a solicitar',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
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
                    //     return 'Campo onbligatorio';
                    //   }
                    //   if (double.tryParse(value) == null) {
                    //     return 'Ingrese un número válido';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _numCuotasController,
                    decoration: InputDecoration(
                      labelText: 'Número de cuotas (meses)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
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
                    //     return 'Campo onbligatorio';
                    //   }
                    //   if (double.tryParse(value) == null) {
                    //     return 'Ingrese un número válido';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: 15),

                  MyButtonSend(
                    onTap: () => _save(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        /**
             * Bloque de carga
             */
        if (solCreditoProvider.isLoading)
          Container(
            color: Colors.black54, // Fondo semi-transparente
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.pink[400],
              ),
            ),
          ),
      ],
    );
  }
}
