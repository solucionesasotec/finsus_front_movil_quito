// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyButtonSaveReceipt extends StatelessWidget {
  final VoidCallback onTap;

  const MyButtonSaveReceipt({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        // margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.pink[400],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Guardar Comprobante',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}