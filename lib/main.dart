/**
 * @project Party Planner
 * @module Aplicativo e rotas
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

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/screens/guest_invitation_screen.dart';
import 'package:party_planner/screens/splash_screen.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/party_background.dart';
import 'package:party_planner/widgets/party_logo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String invitePrefix = '/invite/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      onGenerateRoute: (RouteSettings settings) {
        final name = settings.name ?? '/';
        if (name.startsWith(invitePrefix)) {
          final eventId = name.substring(invitePrefix.length);
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => _InviteLoader(eventId: eventId),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      },
    );
  }
}

/// Carrega o evento do link de convite e abre a tela do convidado.
class _InviteLoader extends StatelessWidget {
  const _InviteLoader({required this.eventId});

  final String eventId;

  Future<Event?> _findEvent() async {
    final events = await EventService().getEvents();
    for (final event in events) {
      if (event.id == eventId) return event;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Event?>(
      future: _findEvent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: PartyBackground(
              showGround: false,
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          );
        }
        final event = snapshot.data;
        if (snapshot.hasError || event == null) {
          return const _InviteNotFound();
        }
        return GuestInvitationScreen(event: event);
      },
    );
  }
}

class _InviteNotFound extends StatelessWidget {
  const _InviteNotFound();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PartyBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PartyLogo(width: 220),
                SizedBox(height: 24),
                Text(
                  'Convite não encontrado',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Confira o link com quem te convidou.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
