/**
 * @project Party Planner
 * @module Painel do anfitrião
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

// lib/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/screens/event_creation_screen.dart';
import 'package:party_planner/screens/event_details_screen.dart';
import 'package:party_planner/screens/welcome_screen.dart';
import 'package:party_planner/services/auth_service.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/party_background.dart';
import 'package:party_planner/widgets/party_logo.dart';

/// Dashboard do anfitrião (Prancheta 1): logo no topo, lista de eventos e o
/// botão "+" central na faixa escura inferior.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final EventService _eventService = EventService();
  final AuthService _authService = AuthService();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _eventService.getEvents();
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = _eventService.getEvents();
    });
  }

  Future<void> _createEvent() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EventCreationScreen()),
    );
    if (result == true) _refreshEvents();
  }

  Future<void> _openEvent(Event event) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
    );
    _refreshEvents();
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PartyBackground(
        showGround: false,
        crowdColor: Colors.white.withValues(alpha: 0.18),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  const PartyLogo(width: 72),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Sair',
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Meus Eventos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Criar evento',
        onPressed: _createEvent,
        backgroundColor: AppColors.ground,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.accent, width: 3),
        ),
        child: const Icon(Icons.add, size: 32),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: AppColors.ground,
        height: 56,
        padding: EdgeInsets.zero,
        child: SizedBox.shrink(),
      ),
    );
  }

  Widget _buildEventList() {
    return FutureBuilder<List<Event>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snapshot.hasError) {
          return _message('Erro ao carregar eventos: ${snapshot.error}');
        }
        final events = snapshot.data ?? const <Event>[];
        if (events.isEmpty) {
          return _message('Nenhum evento ainda.\nToque no + para criar a sua festa!');
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
          itemCount: events.length,
          itemBuilder: (context, index) => _EventCard(
            event: events[index],
            onTap: () => _openEvent(events[index]),
          ),
        );
      },
    );
  }

  Widget _message(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final Event event;
  final VoidCallback onTap;

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final d = event.date;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 56,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      _two(d.day),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${_two(d.month)}/${d.year % 100}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          '${_two(d.hour)}:${_two(d.minute)}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.coral),
            ],
          ),
        ),
      ),
    );
  }
}
