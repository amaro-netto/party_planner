// lib/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart'; // Importa nosso modelo de Evento
import 'package:party_planner/services/event_service.dart'; // Importa nosso serviço de Evento
import 'package:party_planner/screens/event_creation_screen.dart'; // Importa a tela de criação de evento
import 'package:party_planner/screens/event_details_screen.dart'; // ADICIONADO: Importa a tela de detalhes do evento

// A tela de dashboard do administrador, que é um StatefulWidget
// porque ela vai carregar uma lista de eventos que pode mudar.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key}); // Construtor.

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

// O estado da tela de dashboard.
class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final EventService _eventService = EventService(); // Instância do nosso serviço de eventos
  late Future<List<Event>> _eventsFuture; // Um Future para segurar a lista de eventos

  @override
  void initState() {
    super.initState();
    // Quando a tela é iniciada, carregamos os eventos.
    _eventsFuture = _eventService.getEvents();
  }

  // Método para recarregar os eventos (útil após criar um novo evento ou voltar de detalhes).
  void _refreshEvents() {
    setState(() {
      _eventsFuture = _eventService.getEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Eventos'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // Botão para criar um novo evento
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async { // Marcado como 'async' para esperar o resultado da navegação
              // Navega para a tela de criação de evento e espera um resultado de retorno.
              // O 'result' será 'true' se o evento foi criado com sucesso.
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventCreationScreen()),
              );
              // Se o resultado for 'true' (evento criado com sucesso), recarrega a lista
              if (result == true) {
                _refreshEvents(); // Chama o método para recarregar a lista de eventos
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture, // O Future que estamos esperando (carregamento de eventos)
        builder: (context, snapshot) {
          // Verifica o estado da conexão do Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se ainda está carregando os dados, mostra um indicador de progresso.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Se ocorreu um erro ao carregar os dados.
            return Center(child: Text('Erro ao carregar eventos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Se não há dados ou a lista de eventos está vazia.
            return const Center(child: Text('Nenhum evento encontrado. Crie um novo!'));
          } else {
            // Se os dados foram carregados com sucesso.
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4, // Sombra para o card
                  child: ListTile(
                    leading: const Icon(Icons.event), // Ícone de evento
                    title: Text(event.title), // Título do evento
                    subtitle: Text('${event.location} - ${event.date.day}/${event.date.month}/${event.date.year}'), // Local e data
                    onTap: () async { // Marcado como 'async' para esperar o retorno da tela de detalhes
                      // Navega para a tela de detalhes do evento, passando o objeto 'event' clicado.
                      // Aguarda o retorno da tela de detalhes.
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
                      );
                      // Após retornar da tela de detalhes, recarrega os dados.
                      // Isso é útil caso algum dado do evento (convidados, itens) tenha sido alterado lá.
                      _refreshEvents();
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implementar navegação para a tela de edição do evento.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Editar evento: ${event.title}')),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}