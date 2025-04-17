// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bancamovil/features/simulators/widgets/credit_simulator_tab.dart';
import 'package:bancamovil/features/simulators/widgets/investment_simulator_tab.dart';
import 'package:flutter/material.dart';

class SimulatorTabScreen extends StatelessWidget {
  const SimulatorTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Simuladores'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Crédito'),
              Tab(text: 'Inversión'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CreditSimulatorTab(),
            InvestmentSimulatorTab(),
          ],
        ),
      ),
    );
  }
}