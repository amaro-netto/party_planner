import 'package:flutter/material.dart';
// Importa a tela de login que acabamos de criar.
import 'package:party_planner/screens/login_screen.dart';

// A função principal do seu aplicativo. É aqui que tudo começa!
void main() {
  runApp(const MyApp());
}

// MyApp é a classe que representa o seu aplicativo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PartyPlanner', // O nome do seu app
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Cor principal do tema
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Agora, a tela inicial do seu app é a LoginScreen!
      home: const LoginScreen(),
    );
  }
}