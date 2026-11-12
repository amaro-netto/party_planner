/**
 * @project Party Planner
 * @module Área logada do anfitrião
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

// lib/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/screens/event_creation_screen.dart';
import 'package:party_planner/screens/home_tab.dart';
import 'package:party_planner/screens/profile_screen.dart';
import 'package:party_planner/screens/suppliers_screen.dart';
import 'package:party_planner/screens/tasks_screen.dart';
import 'package:party_planner/screens/tips_screen.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/app_bottom_nav.dart';

/// Área logada do anfitrião: abas sobre a faixa escura com o "+" central.
/// Cada aba guarda o próprio estado (IndexedStack).
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AppSession _session = AppSession.instance;

  @override
  void initState() {
    super.initState();
    _session.reset();
  }

  Future<void> _createEvent() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EventCreationScreen()),
    );
    if (result == true) {
      _session.closeEvent();
      _session.goTo(AppTab.inicio);
      _session.eventsChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTab>(
      valueListenable: _session.tab,
      builder: (context, tab, _) => Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: tab.index,
          children: const [
            ProfileScreen(),
            SuppliersScreen(),
            HomeTab(),
            TipsScreen(),
            TasksScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Criar evento',
          onPressed: _createEvent,
          backgroundColor: AppColors.ground,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(side: BorderSide(color: AppColors.accent, width: 3)),
          child: const Icon(Icons.add, size: 32),
        ),
        bottomNavigationBar: AppBottomNav(current: tab, onSelect: _session.goTo),
      ),
    );
  }
}
