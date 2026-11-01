/**
 * @project Party Planner
 * @module Autenticação
 * @author amaro-netto / Amaro Amarante da Silva Netto
 * @contact contato@amaronetto.com.br
 * @date 01/11/2026
 *
 * SOBRE OS DIREITOS AUTORAIS:
 * A arquitetura, design estrutural e desenvolvimento deste software foram
 * realizados pelo autor supracitado. Os direitos patrimoniais e de licença
 * de uso pertencem ao próprio autor, Amaro Amarante da Silva Netto.
 *
 * Ficam resguardados os direitos morais do autor original, sendo vedada a
 * remoção deste aviso de autoria do código-fonte (Lei 9.609/1998).
 */

// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/screens/login_screen.dart';
import 'package:party_planner/services/auth_service.dart';
import 'package:party_planner/widgets/auth_layout.dart';
import 'package:party_planner/widgets/pill_widgets.dart';

/// Tela de Cadastro no visual do layout.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showMessage('Por favor, preencha todos os campos.');
      return;
    }
    if (!email.contains('@')) {
      _showMessage('Informe um e-mail válido.');
      return;
    }
    if (password.length < 6) {
      _showMessage('A senha precisa ter pelo menos 6 caracteres.');
      return;
    }
    if (password != _confirmPasswordController.text) {
      _showMessage('As senhas não coincidem.');
      return;
    }

    setState(() => _isLoading = true);
    final success = await _authService.registerUser(email, password, name: name);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showMessage('Cadastro realizado! Faça login para continuar.');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _showMessage('Falha no cadastro. Tente novamente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      children: [
        PillTextField(
          controller: _nameController,
          hint: 'Nome',
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 14),
        PillTextField(
          controller: _emailController,
          hint: 'Login (e-mail)',
          icon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 14),
        PillTextField(
          controller: _passwordController,
          hint: 'Senha',
          icon: Icons.key,
          obscureText: true,
          textInputAction: TextInputAction.next,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 14),
        PillTextField(
          controller: _confirmPasswordController,
          hint: 'Confirmar senha',
          icon: Icons.key,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _register(),
          enabled: !_isLoading,
        ),
        const SizedBox(height: 24),
        Center(
          child: PillButton(label: 'CADASTRAR', onPressed: _register, isLoading: _isLoading),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: const Text('Já tem conta? Entrar'),
        ),
      ],
    );
  }
}
