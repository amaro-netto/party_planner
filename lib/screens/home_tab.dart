/**
 * @project Party Planner
 * @module Meus eventos e página do evento
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

// lib/screens/home_tab.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/screens/budget_screen.dart';
import 'package:party_planner/screens/event_details_screen.dart';
import 'package:party_planner/screens/faq_screen.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';

/// Espaço livre no fim das listas para não ficar atrás da faixa inferior.
const double kBottomBarSpace = 100;

/// Aba Meus Eventos: lista de eventos ou a página do evento escolhido.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Event?>(
      valueListenable: AppSession.instance.currentEvent,
      builder: (context, event, _) =>
          event == null ? const EventListView() : EventMenuView(event: event),
    );
  }
}

// ---------------------------------------------------------------------------
// Lista de eventos
// ---------------------------------------------------------------------------

class EventListView extends StatefulWidget {
  const EventListView({super.key});

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  final EventService _eventService = EventService();
  final AppSession _session = AppSession.instance;
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _eventService.getEvents();
    _session.eventsVersion.addListener(_refresh);
  }

  @override
  void dispose() {
    _session.eventsVersion.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (!mounted) return;
    setState(() => _eventsFuture = _eventService.getEvents());
  }

  @override
  Widget build(BuildContext context) {
    return PartyPage(
      title: 'Meus Eventos',
      actions: [
        IconButton(
          tooltip: 'Meu perfil',
          icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
          onPressed: () => _session.goTo(AppTab.perfil),
        ),
      ],
      child: FutureBuilder<List<Event>>(
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
            padding: const EdgeInsets.fromLTRB(16, 4, 16, kBottomBarSpace),
            itemCount: events.length,
            itemBuilder: (context, index) => EventCard(
              event: events[index],
              onTap: () => _session.openEvent(events[index]),
            ),
          );
        },
      ),
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

/// Cartão do evento com o bloco de data no degradê.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, this.onTap});

  final Event event;
  final VoidCallback? onTap;

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
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
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
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ground),
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
                          '${_two(d.hour)}:${_two(d.minute)} · ${countdownLabel(d)}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onTap != null) const Icon(Icons.chevron_right, color: AppColors.coral),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Página do evento
// ---------------------------------------------------------------------------

class EventMenuView extends StatelessWidget {
  const EventMenuView({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final session = AppSession.instance;
    void push(Widget page) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

    return PartyPage(
      title: event.title,
      onBack: session.closeEvent,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, kBottomBarSpace),
        children: [
          EventCard(event: event),
          const SectionTitle('Organizar'),
          PillRow(
            icon: Icons.group_outlined,
            label: 'Convidados e convite',
            subtitle: 'Lista, confirmações e link para enviar',
            onTap: () => push(EventDetailsScreen(event: event)),
          ),
          PillRow(
            icon: Icons.checklist,
            label: 'Tarefas',
            subtitle: 'Checklist do que falta preparar',
            onTap: () => session.goTo(AppTab.tarefas),
          ),
          PillRow(
            icon: Icons.payments_outlined,
            label: 'Orçamento',
            subtitle: 'Gastos previstos e total',
            onTap: () => push(BudgetScreen(event: event)),
          ),
          PillRow(
            icon: Icons.storefront_outlined,
            label: 'Fornecedores',
            subtitle: 'Buffet, música, fotos e mais',
            onTap: () => session.goTo(AppTab.fornecedores),
          ),
          const SectionTitle('Ajuda'),
          PillRow(
            icon: Icons.tips_and_updates_outlined,
            label: 'Dicas',
            onTap: () => session.goTo(AppTab.dicas),
          ),
          PillRow(
            icon: Icons.help_outline,
            label: 'Dúvidas',
            onTap: () => push(const FaqScreen()),
          ),
        ],
      ),
    );
  }
}
