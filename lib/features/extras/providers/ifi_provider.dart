
import 'package:bancamovil/core/models/ifi.dart';
import 'package:bancamovil/core/models/ifi_response.dart';
import 'package:bancamovil/core/services/ifi_service.dart';
import 'package:flutter/material.dart';

class IfiProvider with ChangeNotifier {
  final IfiService _ifiService = IfiService();
  bool _isLoading = false;
  late List<Ifi> _ifis = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Ifi> get ifis => _ifis;
  String? get errorMessage => _errorMessage;

  Future<void> getIfis() async {
    _isLoading = true;
    notifyListeners();

    try {
      IfiResponse? ifiResp = await _ifiService.getIfis();
      if (ifiResp != null) {
        if (ifiResp.status == 1) {
          print('Provider bancks: ${ifiResp.data.length}');
          _ifis = ifiResp.data;

        } else {
          switch (ifiResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No hay instituciones financieras';
              break;
            default:
              _errorMessage = 'Error desconocido: ${ifiResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error clasif credits provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }

}
