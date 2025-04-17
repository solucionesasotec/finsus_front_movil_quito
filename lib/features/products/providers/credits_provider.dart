// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/credit.dart';
import 'package:bancamovil/core/models/credits_response.dart';
import 'package:bancamovil/core/services/credits_service.dart';
import 'package:flutter/material.dart';

class CreditsProvider with ChangeNotifier {
  final CreditsService _creditsService = CreditsService();
  bool _isLoading = false;
  late List<Credit> _credits = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Credit> get credits => _credits;
  String? get errorMessage => _errorMessage;

  Future<void> getCredits() async {
    _isLoading = true;
    notifyListeners();

    try {
      CreditsResponse? creditsResp = await _creditsService.getCredits();
      if (creditsResp != null) {
        if (creditsResp.status == 1) {
          _credits = creditsResp.data;

        } else {
          switch (creditsResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No tiene creditos';
              break;
            default:
              _errorMessage = 'Error desconocido: ${creditsResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error credits provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
      _credits = [];
    }

    _isLoading = false;
    notifyListeners();
  }




}
