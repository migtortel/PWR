import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'block_page.dart';
import 'calendar_page.dart';
import 'stats_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final String userId = FirebaseAuth.instance.currentUser!.uid; // Obtener el UID del usuario autenticado

  final List<Widget> pages = []; // Lista de páginas que se inicializará más adelante

  @override
  void initState() {
    super.initState();

    // Inicializar las páginas con el UID del usuario
    pages.addAll([
      StatisticsPage(userId: userId), // Pasar el UID al constructor
      TrainingBlocksPage(userId: userId),
      CalendarPage(userId: userId),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PWR Training'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estadísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Entrenamientos'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}
