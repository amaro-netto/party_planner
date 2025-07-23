// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/services/auth_service.dart'; // Importa nosso serviço de autenticação
import 'package:party_planner/screens/register_screen.dart'; // Importa a tela de registro

// A tela de login, que é um StatefulWidget porque o estado (email, senha, carregamento) muda.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Construtor para a tela de login.

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// O estado da tela de login.
class _LoginScreenState extends State<LoginScreen> {
  // Controladores para pegar o texto dos campos de email e senha.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Instância do nosso serviço de autenticação.
  final AuthService _authService = AuthService();
  // Variável para controlar o estado de carregamento (se está fazendo login).
  bool _isLoading = false;

  // Método chamado quando o botão de login é pressionado.
  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Ativa o estado de carregamento
    });

    // Chama o método de login do nosso serviço de autenticação.
    bool success = await _authService.loginUser(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false; // Desativa o estado de carregamento
    });

    // Mostra uma mensagem de sucesso ou erro na tela.
    if (success) {
      // Navegaria para a tela principal do app em um cenário real.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login bem-sucedido!')),
      );
      // TODO: Navegar para a tela principal do aplicativo (Dashboard).
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha no login. Verifique suas credenciais.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).primaryColor, // Usa a cor principal do tema
      ),
      body: Center(
        child: SingleChildScrollView( // Permite rolar a tela se o teclado aparecer
          padding: const EdgeInsets.all(24.0), // Espaçamento interno
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza os elementos verticalmente
            children: <Widget>[
              // Campo de texto para o email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(), // Borda ao redor do campo
                  prefixIcon: Icon(Icons.email), // Ícone de email
                ),
                keyboardType: TextInputType.emailAddress, // Teclado otimizado para email
              ),
              const SizedBox(height: 16), // Espaço entre os campos
              // Campo de texto para a senha
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock), // Ícone de cadeado
                ),
                obscureText: true, // Esconde o texto da senha
              ),
              const SizedBox(height: 24),
              // Botão de login
              _isLoading
                  ? const CircularProgressIndicator() // Mostra um indicador de carregamento
                  : ElevatedButton(
                      onPressed: _login, // Chama o método _login ao pressionar
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50), // Botão de largura total
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Bordas arredondadas
                        ),
                      ),
                      child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                    ),
              const SizedBox(height: 16),
              // Texto e botão para navegar para a tela de registro
              TextButton(
                onPressed: () {
                  Navigator.push( // Navega para a tela de registro
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Não tem uma conta? Registre-se aqui.', style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}