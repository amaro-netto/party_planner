// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/services/auth_service.dart';
import 'package:party_planner/screens/register_screen.dart';
import 'package:party_planner/screens/admin_dashboard_screen.dart';
import 'package:party_planner/screens/guest_invitation_screen.dart';
import 'package:party_planner/services/event_service.dart';
// REMOVIDO: import 'package:party_planner/models/event.dart'; // Removido, pois o tipo Event é inferido ou usado indiretamente via EventService

// A tela de login, que é um StatefulWidget.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final EventService _eventService = EventService();
  bool _isLoading = false;

  // Método chamado quando o botão de login é pressionado.
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    // Simula a validação de campos
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha email e senha.')),
      );
      setState(() { _isLoading = false; });
      return;
    }

    bool success = await _authService.loginUser(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso! Redirecionando...')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha no login. Verifique suas credenciais.')),
      );
    }
  }

  // Método para navegar para a tela de convidado (para testes)
  void _navigateToGuestInvitation() async {
    setState(() {
      _isLoading = true;
    });
    // 'Event' é o tipo de retorno de _eventService.getEvents(), então o import não é estritamente necessário
    // se o tipo for inferido. A remoção do import de Event está ok aqui.
    var events = await _eventService.getEvents(); 

    setState(() {
      _isLoading = false;
    });

    if (events.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuestInvitationScreen(event: events.first)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum evento simulado disponível para convite. Crie um como anfitrião primeiro.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PartyPlanner - Login'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Não tem uma conta? Registre-se aqui.', style: TextStyle(color: Colors.deepPurple)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _navigateToGuestInvitation,
                child: const Text('Acessar como Convidado (Teste)', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}