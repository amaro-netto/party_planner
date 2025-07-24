// lib/services/event_service.dart
import 'package:flutter/foundation.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/models/guest.dart';
import 'package:party_planner/models/item.dart';

// Esta classe simula um serviço de dados para eventos, convidados e itens.
class EventService {
  // Lista de eventos simulados.
  final List<Event> _mockEvents = [
    Event(
      id: 'event1',
      title: 'Aniversário da Maria',
      location: 'Salão de Festas do Condomínio',
      date: DateTime.now().add(const Duration(days: 10)),
      description: 'Venha celebrar mais um ano de vida da Maria!',
      hostId: 'user123',
      contributionOption: ItemContributionOption.predefinedList,
      predefinedItems: ['Refrigerante', 'Salgadinhos', 'Bolo'],
      allowPlusOne: true, // Adicionado como padrão
    ),
    Event(
      id: 'event2',
      title: 'Churrasco da Firma',
      location: 'Clube dos Funcionários',
      date: DateTime.now().add(const Duration(days: 25)),
      description: 'Churrasco de confraternização anual.',
      hostId: 'user123',
      contributionOption: ItemContributionOption.guestChooses,
      predefinedItems: [],
      allowPlusOne: true,
    ),
    Event(
      id: 'event3',
      title: 'Jantar de Boas-Vindas ao João',
      location: 'Restaurante Sabor da Casa',
      date: DateTime.now().add(const Duration(days: 5)),
      description: 'Vamos dar as boas-vindas ao nosso novo colega, João!',
      hostId: 'user456',
      contributionOption: ItemContributionOption.none,
      predefinedItems: [],
      allowPlusOne: false, // Exemplo de evento que não permite +1
    ),
  ];

  // Um mapa para simular convidados por ID do evento.
  final Map<String, List<Guest>> _mockGuestsByEvent = {
    'event1': [
      Guest(id: 'g1', name: 'João Silva', email: 'joao@example.com', isAttending: true, plusOneCount: 1, itemBringing: 'Bolo'),
      Guest(id: 'g2', name: 'Ana Souza', email: 'ana@example.com', isAttending: false),
    ],
    'event2': [
      Guest(id: 'g3', name: 'Pedro Martins', email: 'pedro@example.com', isAttending: true, plusOneCount: 0, itemBringing: 'Carne de Porco'),
      Guest(id: 'g4', name: 'Mariana Costa', email: 'mariana@example.com', isAttending: true, plusOneCount: 2, itemBringing: 'Cerveja'),
    ],
    'event3': [], // Inicialmente sem convidados
  };

  // Um mapa para simular itens que convidados se comprometeram a levar.
  final Map<String, List<Item>> _mockItemsByEvent = {
    'event1': [
      Item(id: 'ci1', name: 'Refrigerante', quantityNeeded: 0),
      Item(id: 'ci2', name: 'Salgadinhos', quantityNeeded: 0),
    ],
    'event2': [
      Item(id: 'ci3', name: 'Carne Bovina', quantityNeeded: 0),
      Item(id: 'ci4', name: 'Refrigerante', quantityNeeded: 0),
    ],
    'event3': [], // Inicialmente sem itens
  };

  Future<List<Event>> getEvents() async {
    debugPrint('Buscando eventos (simulado)...');
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Eventos simulados carregados.');
    return _mockEvents;
  }

  Future<bool> createEvent(Event event) async {
    debugPrint('Criando evento: ${event.title} (simulado)...');
    await Future.delayed(const Duration(seconds: 1));
    _mockEvents.add(event);
    _mockGuestsByEvent[event.id] = [];
    _mockItemsByEvent[event.id] = [];
    debugPrint('Evento ${event.title} criado com sucesso (simulado).');
    return true;
  }

  Future<List<Guest>> getGuestsForEvent(String eventId) async {
    debugPrint('Buscando convidados para o evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockGuestsByEvent[eventId] ?? [];
  }

  Future<List<Item>> getItemsForEvent(String eventId) async {
    debugPrint('Buscando itens levados pelos convidados para o evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockItemsByEvent[eventId] ?? [];
  }

  Future<bool> addGuestToEvent(String eventId, Guest guest) async {
    debugPrint('Adicionando convidado ${guest.name} ao evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    _mockGuestsByEvent[eventId]?.add(guest);
    debugPrint('Convidado ${guest.name} adicionado com sucesso (simulado).');
    return true;
  }

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

  // NOVO: Método para remover um convidado.
  Future<bool> removeGuestFromEvent(String eventId, String guestId) async {
    debugPrint('Removendo convidado $guestId do evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    final guests = _mockGuestsByEvent[eventId];
    if (guests != null) {
      final initialLength = guests.length;
      guests.removeWhere((g) => g.id == guestId);
      if (guests.length < initialLength) {
        debugPrint('Convidado $guestId removido com sucesso (simulado).');
        return true;
      }
    }
    debugPrint('Falha ao remover convidado $guestId.');
    return false;
  }

  Future<bool> addOrUpdateCommittedItem(String eventId, Item item) async {
    debugPrint('Adicionando/Atualizando item ${item.name} para o evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    final eventItems = _mockItemsByEvent[eventId];
    if (eventItems != null) {
      final existingItemIndex = eventItems.indexWhere((i) => i.name.toLowerCase() == item.name.toLowerCase());
      if (existingItemIndex != -1) {
        eventItems[existingItemIndex] = item;
        debugPrint('Item ${item.name} atualizado com sucesso (simulado).');
      } else {
        eventItems.add(item);
        debugPrint('Item ${item.name} adicionado como novo (simulado).');
      }
      return true;
    }
    debugPrint('Falha ao adicionar/atualizar item ${item.name}.');
    return false;
  }

  // NOVO: Método para remover um item.
  Future<bool> removeItemFromEvent(String eventId, String itemId) async {
    debugPrint('Removendo item $itemId do evento $eventId (simulado)...');
    await Future.delayed(const Duration(milliseconds: 500));
    final items = _mockItemsByEvent[eventId];
    if (items != null) {
      final initialLength = items.length;
      items.removeWhere((i) => i.id == itemId);
      if (items.length < initialLength) {
        debugPrint('Item $itemId removido com sucesso (simulado).');
        return true;
      }
    }
    debugPrint('Falha ao remover item $itemId.');
    return false;
  }
}