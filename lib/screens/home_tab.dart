/**
 * @project Party Planner
 * @module Início e menu do evento
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
import 'package:party_planner/screens/event_creation_screen.dart';
import 'package:party_planner/screens/event_details_screen.dart';
import 'package:party_planner/screens/faq_screen.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';
import 'package:party_planner/widgets/party_logo.dart';

/// Aba Início: sem evento selecionado mostra "Vamos começar a festa?" e a
/// lista de eventos; com evento selecionado mostra o menu do evento.
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
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _eventService.getEvents();
  }

  void _refresh() => setState(() => _eventsFuture = _eventService.getEvents());

  Future<void> _createEvent() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EventCreationScreen()),
    );
    if (result == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return InnerBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const Center(child: PartyLogo(width: 130)),
            const SizedBox(height: 14),
            const Text(
              'Vamos começar a festa?',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.text, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Image.asset(
              'assets/images/crowd_silhouette.png',
              height: 110,
              fit: BoxFit.contain,
              color: AppColors.headerCoral,
              colorBlendMode: BlendMode.srcIn,
              semanticLabel: 'Ilustração de pessoas comemorando',
            ),
            const SizedBox(height: 14),
            const Text(
              'Para iniciar sua lista de tarefas\né preciso criar seu evento:',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Center(
              child: Tooltip(
                message: 'Criar evento',
                child: Material(
                  color: AppColors.headerCoral,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _createEvent,
                    child: const SizedBox(
                      width: 84,
                      height: 84,
                      child: Icon(Icons.add, color: Colors.white, size: 46),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _buildEvents(),
            const SizedBox(height: 12),
            const _QuickLinks(),
          ],
        ),
      ),
    );
  }

  Widget _buildEvents() {
    return SoftCard(
      child: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          final Widget content;
          if (snapshot.connectionState == ConnectionState.waiting) {
            content = const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator(color: AppColors.headerCoral)),
            );
          } else if (snapshot.hasError) {
            content = Text('Erro ao carregar eventos: ${snapshot.error}');
          } else if ((snapshot.data ?? const []).isEmpty) {
            content = const Text(
              'Nenhum evento ainda. Toque no + para criar a sua festa!',
              style: TextStyle(color: AppColors.textSoft),
            );
          } else {
            content = Column(
              children: [
                for (final event in snapshot.data!) _EventRow(event: event),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meus eventos',
                style: TextStyle(color: AppColors.headerCoral, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              content,
            ],
          );
        },
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => AppSession.instance.openEvent(event),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.cake_outlined, color: AppColors.headerCoral),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    daysLeftLabel(event.date),
                    style: const TextStyle(color: AppColors.textSoft, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.headerCoral),
          ],
        ),
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    final session = AppSession.instance;
    Widget link(IconData icon, String label, AppTab tab) => InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => session.goTo(tab),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              children: [
                Icon(icon, color: AppColors.headerCoral),
                const SizedBox(height: 4),
                Text(label, style: const TextStyle(color: AppColors.text, fontSize: 12)),
              ],
            ),
          ),
        );

    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          link(Icons.account_circle, 'Meu perfil', AppTab.perfil),
          link(Icons.star_rounded, 'Dicas', AppTab.dicas),
          link(Icons.volunteer_activism, 'Fornecedores', AppTab.fornecedores),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu do evento
// ---------------------------------------------------------------------------

class EventMenuView extends StatelessWidget {
  const EventMenuView({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final session = AppSession.instance;

    final cards = <_MenuCardData>[
      _MenuCardData('Lista de tarefas', 'O que temos para fazer', Icons.assignment_outlined,
          const Color(0xFF2F4F86), () => session.goTo(AppTab.tarefas)),
      _MenuCardData('Fornecedores', 'Seus fornecedores', Icons.local_shipping_outlined,
          const Color(0xFF3A7BD5), () => session.goTo(AppTab.fornecedores)),
      _MenuCardData('Convidados', 'Sua lista', Icons.contacts_outlined, AppColors.headerCoral,
          () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
              )),
      _MenuCardData('Orçamento', 'Financeiro', Icons.account_balance_wallet_outlined,
          const Color(0xFF6D4C41), () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => BudgetScreen(event: event)),
              )),
      _MenuCardData('Dicas', 'As melhores ideias', Icons.lightbulb_outline, AppColors.pending,
          () => session.goTo(AppTab.dicas)),
      _MenuCardData('Dúvidas', 'Dúvidas frequentes', Icons.help_outline, const Color(0xFF29A8E0),
          () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FaqScreen()),
              )),
    ];

    return InnerBackground(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _EventBanner(event: event, onBack: session.closeEvent),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.2,
              children: [for (final card in cards) _MenuCard(data: card)],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventBanner extends StatelessWidget {
  const _EventBanner({required this.event, required this.onBack});

  final Event event;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.background,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: Stack(
                children: [
                  const Positioned(
                    right: 18,
                    top: 8,
                    child: Icon(Icons.celebration, size: 96, color: Color(0x55FFFFFF)),
                  ),
                  const Positioned(
                    left: 70,
                    bottom: 6,
                    child: Icon(Icons.cake, size: 64, color: Color(0x66FFFFFF)),
                  ),
                  Positioned(
                    left: 4,
                    top: 4,
                    child: IconButton(
                      tooltip: 'Voltar para meus eventos',
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: onBack,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.headerCoral,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    daysLeftLabel(event.date),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      event.title,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.pending,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCardData {
  const _MenuCardData(this.title, this.subtitle, this.icon, this.iconColor, this.onTap);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.data});

  final _MenuCardData data;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: data.onTap,
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 22),
                child: Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.headerCoral,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textSoft, fontSize: 11),
              ),
            ],
          ),
          const Positioned(
            right: 0,
            top: 0,
            child: Icon(Icons.chevron_right, color: AppColors.headerCoral),
          ),
          Positioned(
            right: 4,
            bottom: 0,
            child: Icon(data.icon, size: 44, color: data.iconColor),
          ),
        ],
      ),
    );
  }
}
