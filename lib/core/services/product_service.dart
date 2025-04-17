import 'dart:convert';
import 'package:bancamovil/core/models/product_response.dart';
import 'package:bancamovil/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  Future<ProductResponse?> getProducts() async {
    // Obtieen de memoria el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var queryParams = {
      'token': token,
    };
    var uri = Uri.parse('$baseUrl$productoEndpoint')
        .replace(queryParameters: queryParams);

    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        ProductResponse respProducts = ProductResponse.fromJson(data);
        print('Status Productos: ${respProducts.status}');
        print('Status Productos: ${respProducts.message}');
        print('Status Productos: ${respProducts.data.length}');
        return respProducts;
      }
    } catch (e) {
      throw Exception('Error ProductService: ${e.toString()}');
    }
    return null;
  }
}
