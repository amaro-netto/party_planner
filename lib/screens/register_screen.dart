// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/services/auth_service.dart'; // Importa nosso serviço de autenticação

// A tela de registro, também um StatefulWidget.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key}); // Construtor.

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// O estado da tela de registro.
class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para pegar o texto dos campos de email, senha e confirmação de senha.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  // Instância do nosso serviço de autenticação.
  final AuthService _authService = AuthService();
  // Variável para controlar o estado de carregamento.
  bool _isLoading = false;

  // Método chamado quando o botão de registro é pressionado.
  Future<void> _register() async {
    // Validação básica: verifica se as senhas são iguais.
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return; // Para a execução se as senhas não coincidirem.
    }

    setState(() {
      _isLoading = true; // Ativa o estado de carregamento.
    });

    // Chama o método de registro do nosso serviço de autenticação.
    bool success = await _authService.registerUser(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false; // Desativa o estado de carregamento.
    });

    // Mostra uma mensagem de sucesso ou erro e navega de volta para a tela de login.
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro bem-sucedido! Faça login agora.')),
      );
      Navigator.pop(context); // Volta para a tela anterior (login).
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha no registro. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Theme.of(context).primaryColor, // Usa a cor principal do tema.
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Campo de texto para o email.
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
              // Campo de texto para a senha.
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // Campo de texto para confirmar a senha.
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_open), // Ícone diferente para confirmar senha.
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              // Botão de registro.
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register, // Chama o método _register ao pressionar.
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Registrar', style: TextStyle(fontSize: 18)),
                    ),
              const SizedBox(height: 16),
              // Botão para voltar para a tela de login.
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Volta para a tela anterior.
                },
                child: const Text('Já tem uma conta? Voltar para o Login.', style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}