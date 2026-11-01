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

// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/screens/login_screen.dart';
import 'package:party_planner/screens/register_screen.dart';
import 'package:party_planner/widgets/party_background.dart';
import 'package:party_planner/widgets/party_logo.dart';
import 'package:party_planner/widgets/pill_widgets.dart';

/// Tela Inicial: "Vamos Começar a Festa!" com os botões LOGIN e CADASTRAR.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PartyBackground(
        child: Column(
          children: [
            const Spacer(flex: 2),
            const PartyLogo(width: 280),
            const SizedBox(height: 28),
            const Text(
              'Vamos Começar a Festa!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            PillButton(
              label: 'LOGIN',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
            const SizedBox(height: 14),
            PillButton(
              label: 'CADASTRAR',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
            ),
            const Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
