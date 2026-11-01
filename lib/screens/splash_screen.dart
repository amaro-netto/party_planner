/**
 * @project Party Planner
 * @module Telas de entrada
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

// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/screens/welcome_screen.dart';
import 'package:party_planner/widgets/author_credit.dart';
import 'package:party_planner/widgets/party_background.dart';
import 'package:party_planner/widgets/party_logo.dart';

/// Tela de carregamento ("Bem Vindo ao" + logo + barra de progresso).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration duration = Duration(milliseconds: 2500);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: SplashScreen.duration)
      ..addStatusListener(_onStatus)
      ..forward();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    // Só avança se a splash ainda for a tela visível. Na web, um link de
    // convite empilha a tela de convite por cima e não deve ser substituído.
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const WelcomeScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PartyBackground(
        showGround: false,
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Text(
              'Bem Vindo ao',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const PartyLogo(width: 280),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _controller.value,
                    minHeight: 6,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 5),
            const AuthorCredit(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
