// lib/services/event_service.dart
import 'package:flutter/foundation.dart'; // Para usar debugPrint
import 'package:party_planner/models/event.dart'; // Importa nosso modelo de Evento

// Esta classe simula um serviço de dados para eventos.
// No futuro, aqui estaria a lógica de conexão com Cloud Firestore.
class EventService {
  // Lista de eventos simulados. No futuro, viria de um banco de dados.
  final List<Event> _mockEvents = [
    Event(
      id: 'event1',
      title: 'Aniversário da Maria',
      location: 'Salão de Festas do Condomínio',
      date: DateTime.now().add(const Duration(days: 10)), // Daqui a 10 dias
      description: 'Venha celebrar mais um ano de vida da Maria!',
      hostId: 'user123', // ID de usuário simulado
    ),
    Event(
      id: 'event2',
      title: 'Churrasco da Firma',
      location: 'Clube dos Funcionários',
      date: DateTime.now().add(const Duration(days: 25)), // Daqui a 25 dias
      description: 'Churrasco de confraternização anual.',
      hostId: 'user123',
    ),
    Event(
      id: 'event3',
      title: 'Jantar de Boas-Vindas ao João',
      location: 'Restaurante Sabor da Casa',
      date: DateTime.now().add(const Duration(days: 5)), // Daqui a 5 dias
      description: 'Vamos dar as boas-vindas ao nosso novo colega, João!',
      hostId: 'user456', // Outro ID de usuário simulado
    ),
  ];

  // Método para simular a obtenção de eventos.
  // Em um cenário real, filtraria por eventos do usuário logado.
  Future<List<Event>> getEvents() async {
    debugPrint('Buscando eventos (simulado)...');
    // Simula um atraso de 1 segundo.
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Eventos simulados carregados.');

    // Retorna todos os eventos simulados por enquanto.
    // No futuro, filtraríamos por hostId: _mockEvents.where((e) => e.hostId == currentUserId).toList();
    return _mockEvents;
  }

  // Método para simular a criação de um novo evento.
  Future<bool> createEvent(Event event) async {
    debugPrint('Criando evento: ${event.title} (simulado)...');
    await Future.delayed(const Duration(seconds: 1));
    _mockEvents.add(event); // Adiciona à lista simulada
    debugPrint('Evento ${event.title} criado com sucesso (simulado).');
    return true;
  }

  // TODO: Adicionar métodos para atualizar, deletar e buscar eventos específicos no futuro.
}