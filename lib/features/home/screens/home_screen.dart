// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bancamovil/features/login/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_bar_content.dart';
import '../widgets/bottom_navigation_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void verifySession(sessionProvider) async {
    await sessionProvider.tryAutoLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<AuthProvider>(context);
    verifySession(sessionProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarContent(selectedIndex1: _selectedIndex),
      ),
      body: Center(
        child: BottomNavigationContent(selectedIndex: _selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.wallet),
          //   label: 'Productos',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.pink[400],
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      ),
    );
  }
}



// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               Provider.of<AuthProvider>(context, listen: false).logout();
//               Navigator.of(context).pushReplacementNamed('/login');
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: Text('Welcome to the Home Screen!'),
//       ),
//     );
//   }
// }
