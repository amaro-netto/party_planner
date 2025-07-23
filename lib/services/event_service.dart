// lib/services/event_service.dart
import 'package:flutter/foundation.dart';
import 'package:party_planner/models/event.dart'; // Importa o modelo de Evento (agora com novas props)
import 'package:party_planner/models/guest.dart'; // NOVO: Importa o modelo de Convidado
import 'package:party_planner/models/item.dart';   // NOVO: Importa o modelo de Item

// Esta classe simula um serviço de dados para eventos, convidados e itens.
class EventService {
  // Lista de eventos simulados. Agora com convidados e itens pré-definidos para alguns.
  final List<Event> _mockEvents = [
    Event(
      id: 'event1',
      title: 'Aniversário da Maria',
      location: 'Salão de Festas do Condomínio',
      date: DateTime.now().add(const Duration(days: 10)),
      description: 'Venha celebrar mais um ano de vida da Maria!',
      hostId: 'user123',
      contributionOption: ItemContributionOption.predefinedList, // NOVO: Opção de contribuição
      predefinedItems: ['Refrigerante', 'Salgadinhos', 'Bolo'], // NOVO: Itens pré-definidos
    ),
    Event(
      id: 'event2',
      title: 'Churrasco da Firma',
      location: 'Clube dos Funcionários',
      date: DateTime.now().add(const Duration(days: 25)),
      description: 'Churrasco de confraternização anual.',
      hostId: 'user123',
      contributionOption: ItemContributionOption.guestChooses, // NOVO: Opção de contribuição
      predefinedItems: [], // NOVO: Lista vazia
    ),
    Event(
      id: 'event3',
      title: 'Jantar de Boas-Vindas ao João',
      location: 'Restaurante Sabor da Casa',
      date: DateTime.now().add(const Duration(days: 5)),
      description: 'Vamos dar as boas-vindas ao nosso novo colega, João!',
      hostId: 'user456',
      contributionOption: ItemContributionOption.none, // NOVO: Opção de contribuição
      predefinedItems: [], // NOVO: Lista vazia
    ),
  ];

  // NOVO: Um mapa para simular convidados por ID do evento.
  // Chave: Event ID, Valor: Lista de Guests.
  final Map<String, List<Guest>> _mockGuestsByEvent = {
    'event1': [
      Guest(id: 'g1', name: 'João Silva', email: 'joao@example.com', isAttending: true, plusOneCount: 1, itemBringing: 'Bolo'),
      Guest(id: 'g2', name: 'Ana Souza', email: 'ana@example.com', isAttending: false),
    ],
    'event2': [
      Guest(id: 'g3', name: 'Pedro Martins', email: 'pedro@example.com', isAttending: true, plusOneCount: 0, itemBringing: 'Carne de Porco'),
      Guest(id: 'g4', name: 'Mariana Costa', email: 'mariana@example.com', isAttending: true, plusOneCount: 2, itemBringing: 'Cerveja'),
    ],
  };

  // NOVO: Um mapa para simular itens a levar por ID do evento (itens que convidados estão levando).
  // Chave: Event ID, Valor: Lista de Items.
  final Map<String, List<Item>> _mockItemsByEvent = {
    'event1': [
      // Estes são os itens que os convidados JÁ SE COMPROMETERAM a levar
      // (não confundir com predefinedItems do Evento).
      Item(id: 'ci1', name: 'Refrigerante', quantityNeeded: 0),
      Item(id: 'ci2', name: 'Salgadinhos', quantityNeeded: 0),
    ],
    'event2': [
      Item(id: 'ci3', name: 'Carne Bovina', quantityNeeded: 0),
      Item(id: 'ci4', name: 'Refrigerante', quantityNeeded: 0),
    ],
  };

  // Método para simular a obtenção de eventos.
  Future<List<Event>> getEvents() async {
    debugPrint('Buscando eventos (simulado)...');
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Eventos simulados carregados.');
    return _mockEvents;
  }

  // Método para simular a criação de um novo evento.
  // Agora o 'event' já incluirá 'contributionOption' e 'predefinedItems'.
  Future<bool> createEvent(Event event) async {
    debugPrint('Criando evento: ${event.title} (simulado)...');
    await Future.delayed(const Duration(seconds: 1));
    _mockEvents.add(event); // Adiciona à lista simulada
    _mockGuestsByEvent[event.id] = []; // Inicializa a lista de convidados para o novo evento
    _mockItemsByEvent[event.id] = [];   // Inicializa a lista de itens levados pelos convidados
    debugPrint('Evento ${event.title} criado com sucesso (simulado).');
    return true;
  }

  // Método para simular a obtenção de convidados para um evento específico.
  Future<List<Guest>> getGuestsForEvent(String eventId) async {
    debugPrint('Buscando convidados para o evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockGuestsByEvent[eventId] ?? [];
  }

  // Método para simular a obtenção de itens para um evento específico.
  Future<List<Item>> getItemsForEvent(String eventId) async {
    debugPrint('Buscando itens levados pelos convidados para o evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockItemsByEvent[eventId] ?? [];
  }

  // Método para simular a adição de um convidado a um evento.
  Future<bool> addGuestToEvent(String eventId, Guest guest) async {
    debugPrint('Adicionando convidado ${guest.name} ao evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    _mockGuestsByEvent[eventId]?.add(guest);
    debugPrint('Convidado ${guest.name} adicionado com sucesso (simulado).');
    return true;
  }

  // Método para simular a atualização de um convidado.
  Future<bool> updateGuest(String eventId, Guest updatedGuest) async {
    debugPrint('Atualizando convidado ${updatedGuest.name} no evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    final guests = _mockGuestsByEvent[eventId];
    if (guests != null) {
      final index = guests.indexWhere((g) => g.id == updatedGuest.id);
      if (index != -1) {
        guests[index] = updatedGuest;
        debugPrint('Convidado ${updatedGuest.name} atualizado com sucesso (simulado).');
        return true;
      }
    }
    debugPrint('Falha ao atualizar convidado ${updatedGuest.name}.');
    return false;
  }

  // Método para simular a adição/atualização de um item (que o anfitrião precisa que levem ou que um convidado vai levar).
  // Este método é mais genérico e pode ser usado para adicionar tanto itens pré-definidos
  // (na criação do evento) quanto itens que convidados se comprometem a trazer.
  Future<bool> addOrUpdateCommittedItem(String eventId, Item item) async {
    debugPrint('Adicionando/Atualizando item ${item.name} para o evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    final eventItems = _mockItemsByEvent[eventId];
    if (eventItems != null) {
      final existingItemIndex = eventItems.indexWhere((i) => i.name.toLowerCase() == item.name.toLowerCase());
      if (existingItemIndex != -1) {
        eventItems[existingItemIndex] = item; // Substitui o item existente
        debugPrint('Item ${item.name} atualizado com sucesso (simulado).');
      } else {
        eventItems.add(item); // Adiciona como novo
        debugPrint('Item ${item.name} adicionado como novo (simulado).');
      }
      return true;
    }
    debugPrint('Falha ao adicionar/atualizar item ${item.name}.');
    return false;
  }
}