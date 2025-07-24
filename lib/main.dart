// lib/main.dart
import 'package:flutter/material.dart';
import 'package:party_planner/screens/login_screen.dart';
import 'package:party_planner/screens/guest_invitation_screen.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/models/event.dart'; // NOVO: IMPORT NECESSÁRIO para o modelo Event

// Instância global do EventService para ser acessível na rota
final EventService _eventService = EventService();

// A função principal do seu aplicativo.
void main() {
  runApp(const MyApp());
}

// MyApp é a classe que representa o seu aplicativo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PartyPlanner',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Usamos onGenerateRoute para lidar com o roteamento dinâmico por links
      onGenerateRoute: (RouteSettings settings) {
        // Verifica se a rota é para um convite
        if (settings.name != null && settings.name!.startsWith('/invite/')) {
          // Extrai o ID do evento da URL
          final eventId = settings.name!.substring('/invite/'.length);

          // Retorna uma rota para a tela de convite
          return MaterialPageRoute(
            builder: (context) => FutureBuilder<List<Event>>(
              future: _eventService.getEvents(), // Busca todos os eventos simulados
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(child: Text('Erro ao carregar evento: ${snapshot.error}')),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // Tenta encontrar o evento com o ID correspondente
                  // CORREÇÃO: Usamos 'e?.id' para segurança nula e '?? false' para a condição
                  final event = snapshot.data!.firstWhere(
                    (e) => e.id == eventId, // Acesso ao 'id' pode ser nulo em FutureBuilder<List<Event>>
                    orElse: () {
                      // Se o evento não for encontrado, podemos retornar uma tela de erro
                      // ou, como fallback, o primeiro evento se houver, ou nulo.
                      // Para simplicidade, vamos retornar o primeiro evento ou lançar um erro.
                      debugPrint('Evento com ID $eventId não encontrado. Usando o primeiro evento ou falhando.');
                      // Se houver mais de um mock event, pode retornar o primeiro.
                      if (snapshot.data!.isNotEmpty) return snapshot.data!.first;
                      // Caso contrário, algo está errado, podemos lançar um erro mais explícito.
                      throw Exception('Evento não encontrado e nenhum fallback disponível.');
                    },
                  );
                  // Retorna a tela de convite com o evento encontrado
                  return GuestInvitationScreen(event: event);
                } else {
                  return const Scaffold(
                    body: Center(child: Text('Evento não encontrado ou sem dados.')),
                  );
                }
              },
            ),
          );
        }
        // Se não for uma rota de convite, retorna a tela de login como padrão
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      },
    );
  }
}