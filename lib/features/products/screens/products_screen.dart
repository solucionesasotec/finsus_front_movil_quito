import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  // Lista de productos (puede venir de un servicio)
  final List<Map<String, dynamic>> products = [
    {"name": "AHORROS A LA VISTA", "balance": 1500.0, "type": "Ahorro"},
    {"name": "CERTIFICADOS DE APORTACION", "balance": 200.0, "type": "Corriente"},
    {"name": "CREDITO CONSUMO", "balance": 5000.0, "type": "Inversión"},
    {"name": "CRÉDITO CONSUMO PRIORITARIO", "balance": 300.0, "type": "Crédito"},
  ];

  @override
  Widget build(BuildContext context) {
    // final sessionProvider = Provider.of<AuthProvider>(context, listen: false);
    // sessionProvider.setContext(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text(product['name']),
              subtitle: Text('Tipo: ${product['type']}'),
              trailing: Text(
                '\$ ${product['balance'].toStringAsFixed(2)}',
                style: TextStyle(
                  color: product['balance'] < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/productDetails',
                  arguments: product,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
