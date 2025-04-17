// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables, avoid_print, slash_for_doc_comments

import 'package:bancamovil/core/models/account.dart';
import 'package:bancamovil/core/models/partner_account.dart';
import 'package:bancamovil/core/models/user.dart';
import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:bancamovil/features/products/providers/accounts_provider.dart';
import 'package:bancamovil/features/transactions/provider/transaction_provider.dart';
import 'package:bancamovil/features/transactions/widgets/dropdown_account_type.dart';
import 'package:bancamovil/features/transactions/widgets/dropdown_banks.dart';
import 'package:bancamovil/features/transactions/widgets/dropdown_concept.dart';
import 'package:bancamovil/features/transactions/widgets/dropdown_id_type.dart';
import 'package:bancamovil/features/transactions/widgets/my_button_internals.dart';
import 'package:bancamovil/features/transactions/widgets/my_button_validate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dropdown_products.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PartnerAccount cuenta =
        ModalRoute.of(context)!.settings.arguments as PartnerAccount;

    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transacciones'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Internas'),
              Tab(text: 'Interbancarias'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab para Transacciones Internas
            InternalTransactionsTab(
              cuenta: cuenta,
            ),

            // Tab para Transferencias Interbancarias
            InterbankTransactionsTab(
              cuenta: cuenta,
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * ==============================================================================================
 * Widget para Transferencias Internas
 * ==============================================================================================
 */
class InternalTransactionsTab extends StatefulWidget {
  // const InternalTransactionsTab({super.key});
  final PartnerAccount cuenta;
  InternalTransactionsTab({required this.cuenta});

  @override
  State<InternalTransactionsTab> createState() =>
      _InternalTransactionsTabState();
}

class _InternalTransactionsTabState extends State<InternalTransactionsTab> {
  final _formKeyInterna = GlobalKey<FormState>();

  final _montoController = TextEditingController();
  String? _tipoProducto;
  final _numCuentaController = TextEditingController();
  var _nomSocioController = TextEditingController();
  var isExistSocio = false;
  final _descController = TextEditingController();

  Future<void> _createSMS(context, smsProvider) async {
    // ademas de funciones asyncronas para validacion de existencia de cierto valor encampos

    if (_formKeyInterna.currentState?.validate() == true) {
      _formKeyInterna.currentState?.save();

      final sessionProvider = Provider.of<AuthProvider>(context, listen: false);
      User? usuario = sessionProvider.user;

      print('--- Fomrulario VALIDO !!');
      // Envio de SMS / email
      try {
        await smsProvider.sendSms();

        if (smsProvider.isValidated) {
          print('Mensaje enviado !!');
          // Navigator.pushNamed(context, '/validator');
          Navigator.pushNamed(
            context,
            '/validator/internal',
            // Enviamos el objeto como argumento
            arguments: {
              'producto': widget.cuenta.id.codProducto.toString(),
              'cuenta': widget.cuenta.id.codCuenta.toString(),
              'monto': _montoController.text,
              'productoSocio': _tipoProducto.toString(),
              'cuentaSocio': _numCuentaController.text,
              'descripcion': _descController.text,
              'nombreSocioOrdenante':
                  '${usuario!.apeSocio} ${usuario.nomSocio}',
              'nombreSocio': _nomSocioController.text,
            },
          );
          // return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(smsProvider.errorMessage),
              backgroundColor: Colors.red[400],
            ),
          );
        }
      } catch (e) {
        print('Error envio sms fallido: ${e}');
      }
    } else {
      print('--- Formulario NO VALIDO');
    }
  }

  Future<void> _validateAccount() async {
    // void _validateAccount() {

    final accountProvider =
        Provider.of<AccountsProvider>(context, listen: false);
    try {
      await accountProvider.getAccount(
          _tipoProducto.toString(), _numCuentaController.text);
      if (accountProvider.accounts.isNotEmpty) {
        setState(() {
          _nomSocioController = TextEditingController(
            text: accountProvider.accounts[0].nomCuenta,
          );
          isExistSocio = true;
        });
      } else {
        // print('No existe cuenta de beneficiario');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No existe cuenta de beneficiario'),
            backgroundColor: Colors.red[400],
          ),
        );
        isExistSocio = false;
      }
    } catch (e) {
      print('Error UI provider accounts');
    }
  }

  void handleProductSelected(String? product) {
    setState(() {
      _tipoProducto = product; // Actualiza el valor en el widget padre
    });
  }

  void verifySession(sessionProvider) async {
    await sessionProvider.tryAutoLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<AuthProvider>(context);
    verifySession(sessionProvider);
    final smsProvider = Provider.of<TransactionProvider>(context);

    final accountProvider =
        Provider.of<AccountsProvider>(context, listen: false);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKeyInterna,
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text('Transacciones Internas',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      Text('Producto: ${widget.cuenta.nomProducto}',
                          style: TextStyle(fontSize: 13)),
                      SizedBox(height: 8),
                      Text('Saldo disponible', style: TextStyle(fontSize: 15)),
                      Text('\$${widget.cuenta.valSaldo}',
                          style: TextStyle(fontSize: 30)),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                TextFormField(
                  controller: _montoController,
                  decoration: InputDecoration(
                    labelText: 'Monto a transferir',
                    border: OutlineInputBorder(),
                    hintText: 'Ejm: 100.00',
                    // prefixIcon: Padding(
                    //   padding: EdgeInsets.only(left: 28.0, top: 10.0),
                    //   child: Text(
                    //     '\$',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    // ),
                  ),
                  // keyboardType: TextInputType.number,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    double? monto = double.tryParse(value);
                    if (monto == null) {
                      return 'Ingrese un monto válido';
                    }
                    double saldo = widget.cuenta.valEfectivo;
                    if (monto > saldo) {
                      return 'El monto excede el saldo disponible';
                    }
                    return null; // Validaciones locales pasaron
                  },
                ),

                // Opciones tipo de cuenta
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: DropdownProducts(
                        onProductSelected: handleProductSelected,
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // TextFormField(
                //   controller: _numCuentaController,
                //   // decoration: InputDecoration(labelText: 'Número de cuenta'),
                //   decoration: InputDecoration(
                //     labelText: 'Número de cuenta de beneficiario',
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Campo obligatorio';
                //     }
                //     return null; // Validaciones locales pasaron
                //   },
                // ),

                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _numCuentaController,
                        decoration: InputDecoration(
                          labelText: 'Nro de cuenta beneficiario',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          isExistSocio = false;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obligatorio';
                          }
                          return null; // Validaciones locales pasaron
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    MyButtonValidate(
                      onTap: () => _validateAccount(),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                if (accountProvider.isLoading)
                  Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.pink[400],
                      ),
                    ),
                  ),

                if (isExistSocio)
                  TextFormField(
                    controller: _nomSocioController,
                    decoration: InputDecoration(
                      labelText: 'Beneficiario',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false,
                  ),
                SizedBox(height: 10),

                if (isExistSocio)
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio';
                      }
                      return null; // Validaciones locales pasaron
                    },
                  ),
                SizedBox(height: 20),
                if (isExistSocio)
                  MyButtonInternals(
                    onTap: () => _createSMS(context, smsProvider),
                  ),
              ],
            ),
          ),
        ),

        /**
         * Bloque de carga
         */
        if (smsProvider.isLoading)
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

/**
 * ==============================================================================================
 * Widget para Transferencias Interbancarias
 * ==============================================================================================
 */

class InterbankTransactionsTab extends StatefulWidget {
  // const InterbankTransactionsTab({super.key});
  final PartnerAccount cuenta;
  InterbankTransactionsTab({required this.cuenta});

  @override
  State<InterbankTransactionsTab> createState() =>
      _InterbankTransactionsTabState();
}

class _InterbankTransactionsTabState extends State<InterbankTransactionsTab> {
  final _formKeyInterbank = GlobalKey<FormState>();

  final _montoController = TextEditingController();
  String? _codBanco;
  String? _nomBanco;
  String? _tipoCuenta;
  final _numCuentaController = TextEditingController();
  String? _tipoId;
  final _numIdController = TextEditingController();
  String? _concepto;
  final _nomBeneficiarioController = TextEditingController();
  final _descripcionController = TextEditingController();

  Future<void> _createSMS(context, smsProvider) async {
    if (_formKeyInterbank.currentState?.validate() == true) {
      _formKeyInterbank.currentState?.save();

      print('--- Formulario VALIDO !!');

      try {
        await smsProvider.sendSms();

        if (smsProvider.isValidated) {
          final sessionProvider =
              Provider.of<AuthProvider>(context, listen: false);
          User? usuario = sessionProvider.user;

          print('Mensaje enviado !!');
          // print('Interbank-prod : ${widget.cuenta.id.codProducto.toString()}');
          // print('Interbank-cuenta : ${widget.cuenta.id.codCuenta.toString()}');

          // print('Interbank-monto : ${_montoController.text}');
          // print('Interbank-bank : ${_codBanco}');
          // print('Interbank-NOMBRE DEL BANCO : ${_nomBanco}');
          // print('Interbank-tipoCta : ${_tipoCuenta}');
          // print('Interbank-numCta : ${_numCuentaController.text}');
          // print('Interbank-tipoId : ${_tipoId}');
          // print('Interbank-numId : ${_numIdController.text}');
          // print('Interbank-concpt : ${_concepto}');
          // print('Interbank-nomBenf : ${_nomBeneficiarioController.text}');
          // print('Interbank-descr : ${_descripcionController.text}');

          Navigator.pushNamed(
            context,
            '/validator/interbank',
            // Enviamos el objeto como argumento
            arguments: {
              'producto': widget.cuenta.id.codProducto.toString(),
              'cuenta': widget.cuenta.id.codCuenta.toString(),
              'monto': _montoController.text,
              'banco': _codBanco.toString(),
              'nomBanco': _nomBanco.toString(),
              'identificacion': _numIdController.text,
              'beneficiario': _nomBeneficiarioController.text,
              'tipocuenta': _tipoCuenta.toString(),
              'descripcion': _descripcionController.text,
              'spiconcepto': _concepto.toString(),
              'ctaacreditar': _numCuentaController.text,
              'tipocuentaacreditar': _tipoCuenta.toString(),
              'nombreSocioOrdenante':
                  '${usuario!.apeSocio} ${usuario.nomSocio}',
              'nombreSocio': _nomBeneficiarioController.text,
            },
          );
          // return;
        }
      } catch (e) {
        print('Error envio sms fallido: ${e}');
      }
    } else {
      print('--- Formulario NO VALIDO');
    }
  }

  void handleBankSelected(String? bank, String? nomBanco) {
    setState(() {
      _codBanco = bank;
      _nomBanco = nomBanco; // Actualiza el valor en el widget padre
    });
  }

  void handleAccountTypeSelected(String? accountType) {
    setState(() {
      _tipoCuenta = accountType;
    });
  }

  void handleIdTypeSelected(String? idType) {
    setState(() {
      _tipoId = idType;
    });
  }

  void handleConceptSelected(String? concept) {
    setState(() {
      _concepto = concept;
    });
  }

  void verifySession(sessionProvider) async {
    await sessionProvider.tryAutoLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<AuthProvider>(context);
    verifySession(sessionProvider);

    final smsProvider = Provider.of<TransactionProvider>(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKeyInterbank,
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text('Transferencias Interbancarias',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      Text('Producto: ${widget.cuenta.nomProducto}',
                          style: TextStyle(fontSize: 13)),
                      SizedBox(height: 8),
                      Text('Saldo disponible', style: TextStyle(fontSize: 15)),
                      Text('\$${widget.cuenta.valSaldo}',
                          style: TextStyle(fontSize: 30)),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _montoController,
                  decoration: InputDecoration(
                    labelText: 'Monto a transferir',
                    border: OutlineInputBorder(),
                    hintText: 'Ejm: 100.00',
                  ),
                  // keyboardType: TextInputType.number,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    double? monto = double.tryParse(value);
                    if (monto == null) {
                      return 'Ingrese un monto válido';
                    }
                    double saldo = widget.cuenta.valEfectivo;
                    if (monto > saldo) {
                      return 'El monto excede el saldo disponible';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: DropdownBanks(
                        onBankSelected: handleBankSelected,
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: DropdownAccountType(
                        onAccountTypeSelected: handleAccountTypeSelected,
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _numCuentaController,
                  decoration: InputDecoration(
                    labelText: 'Nro de cuenta',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: DropdownIdType(
                        onIdTypeSelected: handleIdTypeSelected,
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _numIdController,
                  decoration: InputDecoration(
                    labelText: 'Nro de identificación',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: DropdownConcepts(
                        onConceptSelected: handleConceptSelected,
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nomBeneficiarioController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de beneficiario',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                MyButtonInternals(
                  onTap: () => _createSMS(context, smsProvider),
                ),
              ],
            ),
          ),
        ),

        /**
         * Bloque de carga
         */
        if (smsProvider.isLoading)
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
