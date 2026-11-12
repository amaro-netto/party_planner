/**
 * @project Party Planner
 * @module Perfil do anfitrião
 * @author amaro-netto / Amaro Amarante da Silva Netto
 * @contact contato@amaronetto.com.br
 * @date 12/11/2026
 *
 * SOBRE OS DIREITOS AUTORAIS:
 * A arquitetura, design estrutural e desenvolvimento deste software foram
 * realizados pelo autor supracitado. Os direitos patrimoniais e de licença
 * de uso pertencem ao próprio autor, Amaro Amarante da Silva Netto.
 *
 * Ficam resguardados os direitos morais do autor original, sendo vedada a
 * remoção deste aviso de autoria do código-fonte (Lei 9.609/1998).
 */

// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/screens/home_tab.dart';
import 'package:party_planner/screens/welcome_screen.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/services/auth_service.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/author_credit.dart';
import 'package:party_planner/widgets/inner_layout.dart';

/// Meu perfil: dados da sessão, atalhos e sair.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Sair da conta?',
      message: 'Você volta para a tela inicial.',
      confirmLabel: 'SAIR',
    );
    if (!ok) return;
    await AuthService().logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final session = AppSession.instance;
    final rawName = auth.currentUserName?.trim() ?? '';
    final name = rawName.isEmpty ? 'Anfitrião' : rawName;
    final email = auth.currentUserEmail ?? 'Sessão de demonstração';

    return PartyPage(
      title: 'Meu perfil',
      onBack: () => session.goTo(AppTab.inicio),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, kBottomBarSpace),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Text(
                name.characters.first.toUpperCase(),
                style: const TextStyle(color: AppColors.coral, fontSize: 32, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(email, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          PillRow(
            icon: Icons.celebration_outlined,
            label: 'Meus eventos',
            onTap: () {
              session.closeEvent();
              session.goTo(AppTab.inicio);
            },
          ),
          PillRow(icon: Icons.logout, label: 'Sair', onTap: () => _logout(context)),
          const SizedBox(height: 20),
          const Center(child: AuthorCredit(width: 150)),
        ],
      ),
    );
  }
}
