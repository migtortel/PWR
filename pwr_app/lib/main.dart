import 'package:flutter/material.dart';

import 'login_page.dart';


void main() => runApp(const PersonalTrainingApp());

class PersonalTrainingApp extends StatelessWidget {
  const PersonalTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PWR Training',
      theme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}

// Página de Login

// Dashboard con navegación

// Página de Estadísticas

// Página del Calendario

// Página de Bloques

// Página de Entrenamientos




