// lib/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/screens/event_creation_screen.dart';
import 'package:party_planner/screens/event_details_screen.dart';

// A tela de dashboard do administrador, que é um StatefulWidget
// porque ela vai carregar uma lista de eventos que pode mudar.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

// O estado da tela de dashboard.
class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final EventService _eventService = EventService();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventCreationScreen()),
              );
              if (result == true) {
                _refreshEvents();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar eventos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum evento encontrado. Crie um novo!'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(event.title),
                    subtitle: Text('${event.location} - ${event.date.day}/${event.date.month}/${event.date.year}'),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
                      );
                      _refreshEvents();
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
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