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

// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/screens/admin_dashboard_screen.dart';
import 'package:party_planner/screens/guest_invitation_screen.dart';
import 'package:party_planner/screens/register_screen.dart';
import 'package:party_planner/services/auth_service.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/widgets/auth_layout.dart';
import 'package:party_planner/widgets/pill_widgets.dart';

/// Tela de Login no visual do layout (campos em pílula sobre o degradê).
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Por favor, preencha login e senha.');
      return;
    }

    setState(() => _isLoading = true);
    final success = await _authService.loginUser(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        (route) => false,
      );
    } else {
      _showMessage('Falha no login. Verifique suas credenciais.');
    }
  }

  /// Atalho de teste para abrir a visão do convidado com o primeiro evento.
  Future<void> _openGuestInvitation() async {
    setState(() => _isLoading = true);
    final events = await _eventService.getEvents();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (events.isEmpty) {
      _showMessage('Nenhum evento disponível. Crie um como anfitrião primeiro.');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GuestInvitationScreen(event: events.first)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      children: [
        PillTextField(
          controller: _emailController,
          hint: 'Login',
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
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _login(),
          enabled: !_isLoading,
        ),
        const SizedBox(height: 24),
        Center(
          child: PillButton(label: 'ENTRAR', onPressed: _login, isLoading: _isLoading),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: const Text('Não tem conta? Cadastre-se'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _openGuestInvitation,
          style: TextButton.styleFrom(foregroundColor: Colors.white70),
          child: const Text('Acessar como convidado (teste)'),
        ),
      ],
    );
  }
}
