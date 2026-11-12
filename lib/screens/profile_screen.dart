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
import 'package:party_planner/screens/welcome_screen.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/services/auth_service.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/author_credit.dart';
import 'package:party_planner/widgets/inner_layout.dart';

/// Aba Meu perfil: dados da sessão, atalhos e sair.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final ok = await showConfirmDialog(context, 'Tem certeza que deseja sair?');
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
    final name = auth.currentUserName?.trim().isNotEmpty == true ? auth.currentUserName!.trim() : 'Anfitrião';
    final email = auth.currentUserEmail ?? 'Sessão de demonstração';

    Widget option(IconData icon, String label, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SoftCard(
            onTap: onTap,
            child: Row(
              children: [
                Icon(icon, color: AppColors.headerCoral),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600)),
                ),
                const Icon(Icons.chevron_right, color: AppColors.headerCoral),
              ],
            ),
          ),
        );

    return InnerBackground(
      child: Column(
        children: [
          CoralHeader(
            title: 'Meu perfil',
            icon: Icons.account_circle,
            onBack: () => session.goTo(AppTab.inicio),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.headerCoral,
                    child: Text(
                      name.characters.first.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Text(email, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSoft)),
                const SizedBox(height: 24),
                option(Icons.celebration_outlined, 'Meus eventos', () {
                  session.closeEvent();
                  session.goTo(AppTab.inicio);
                }),
                option(Icons.volunteer_activism, 'Fornecedores', () => session.goTo(AppTab.fornecedores)),
                option(Icons.lightbulb_outline, 'Dicas & Ideias', () => session.goTo(AppTab.dicas)),
                option(Icons.logout, 'Sair', () => _logout(context)),
                const SizedBox(height: 24),
                const Center(child: AuthorCredit(width: 150)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
