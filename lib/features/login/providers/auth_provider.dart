// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:bancamovil/core/models/bank_account.dart';
import 'package:bancamovil/core/models/company.dart';
import 'package:bancamovil/core/models/company_response.dart';
import 'package:bancamovil/core/models/partner_account.dart';
import 'package:bancamovil/core/models/login_response.dart';
import 'package:bancamovil/core/models/user.dart';
import 'package:bancamovil/core/models/user_response.dart';
import 'package:bancamovil/core/services/bank_account_service.dart';
import 'package:bancamovil/core/services/company_service.dart';
import 'package:bancamovil/core/services/partner_accounts_service.dart';
import 'package:bancamovil/core/services/auth_service.dart';
import 'package:bancamovil/core/services/user_service.dart';
import 'package:bancamovil/features/login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final PartnerAccountsService _accountService = PartnerAccountsService();
  final CompanyService _companyService = CompanyService();
    final BankAccountService _bankAccountService = BankAccountService();

  bool _isAuthenticated = false;
  bool _isNewUser = false;
  bool _isLoading = false;
  String? _token;
  String? _errorMessage;
  User? _user;
  List<PartnerAccount>? _accounts;
  List<BankAccount>? _bankAccount;
  Company? _company;

  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuthenticated => _isAuthenticated;
  bool get isNewUser => _isNewUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  List<PartnerAccount>? get accounts => _accounts;
  List<BankAccount>? get bankAccount => _bankAccount;
  Company? get company => _company;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  // Login service
  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _isNewUser = false;
      LoginResponse? respLogin = await _authService.login(username, password);
      if (respLogin != null) {
        if (respLogin.status == 1) {
          _isAuthenticated = true;
          _token = respLogin.list;

          _expiryDate =
              DateTime.now().add(Duration(minutes: 30)); //Usar time de token

          // Guarda token y fecha de expiración en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', _token!);
          prefs.setString('expiryDate', _expiryDate!.toIso8601String());
          // print('LOG-INFO: Date expire: ${_expiryDate!.toIso8601String()}');

          //User service
          UserResponse? respUser = await _userService.getUser(respLogin.list);
          if (respUser != null) {
            if (respUser.status == 1) {
              _user = respUser.list;

              //Company Service
              CompanyResponse? respCompany =
                  await _companyService.getEmpresa('1');
              if (respCompany != null) {
                if (respCompany.status == 1) {
                  _company = respCompany.list;
                }
              }
            }
          }
        }

        if (respLogin.status == -2) {
          _isNewUser = true;
          _token = respLogin.list;

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', _token!);
          prefs.setString('expiryDate', _expiryDate!.toIso8601String());
        } else {
          switch (respLogin.list) {
            case 'EMPTY_USERNAME':
              _errorMessage = 'Ingrese un usuario';
              break;
            case 'EMPTY_PASSWORD':
              _errorMessage = 'Ingrese una contraseña';
              break;
            case 'WRONG_USERNAME':
              _errorMessage = 'Usuario incorrecto';
              break;
            case 'MISSING_CREDENTIAL':
              _errorMessage = 'No existe las credenciales del usuario';
              break;
            case 'WRONG_PASSWORD':
              _errorMessage = 'Contraseña incorrecta';
              break;
            case 'DISABLED':
              _errorMessage =
                  'Usuario bloqueado, comunicarse con la institucion financiera';
              break;
            default:
              _errorMessage = 'Error desconocido: ${respLogin.list}';
          }
        }
        // notifyListeners();
      }
    } catch (e) {
      print("Error login provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    _isAuthenticated = false;
    _token = null;

    _expiryDate = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('expiryDate');

    // Mostramos el diálogo de sesión expirada
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Sesión terminada'),
        content:
            Text('La sesión ha caducado. Por favor, inicia sesión nuevamente.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Navigator.of(ctx).pushReplacementNamed('/login');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) =>
                    false, // Elimina todas las rutas anteriores
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );

    notifyListeners();
  }

  // Revisa si hay un token almacenado y si aún es válido
  Future<void> tryAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token') || !prefs.containsKey('expiryDate')) {
      return;
    }

    final storedToken = prefs.getString('token');
    final expiryDate = DateTime.parse(prefs.getString('expiryDate')!);

    if (expiryDate.isBefore(DateTime.now())) {
      return;
    }

    _token = storedToken;
    _expiryDate = expiryDate;
    _isAuthenticated = true;

    _autoLogout(context); // Re-inicia el temporizador de cierre de sesión

    notifyListeners();
  }

  // Función para manejar el auto-logout cuando el token expira
  void _autoLogout(BuildContext context) {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () {
      logout(context);
    });
  }
}
