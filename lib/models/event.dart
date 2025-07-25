// lib/models/event.dart

// Enumeração para definir as opções de contribuição de itens.
enum ItemContributionOption {
  predefinedList,
  none,
  guestChooses,
}

// Um modelo simples para representar um Evento no PartyPlanner.
class Event {
  final String id;
  final String title;
  final String location;
  final DateTime date;
  final String description;
  final String hostId;
  final ItemContributionOption contributionOption;
  final List<String> predefinedItems;
  final bool allowPlusOne; // NOVO: Permite ou não acompanhantes (+1)

  // Construtor da classe Event.
  const Event({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
    required this.hostId,
    this.contributionOption = ItemContributionOption.guestChooses,
    this.predefinedItems = const [],
    this.allowPlusOne = true, // NOVO: Padrão como 'permitido'
  });

  // Um método (opcional, mas útil) para converter um Evento em um mapa de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'date': date.toIso8601String(),
      'description': description,
      'hostId': hostId,
      'contributionOption': contributionOption.name,
      'predefinedItems': predefinedItems,
      'allowPlusOne': allowPlusOne, // NOVO: Adiciona ao mapa
    };
  }

  // Um método (opcional, mas útil) para criar um objeto Event a partir de um mapa de dados.
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      location: map['location'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
      hostId: map['hostId'] as String,
      contributionOption: ItemContributionOption.values.firstWhere(
        (e) => e.name == map['contributionOption'],
        orElse: () => ItemContributionOption.guestChooses,
      ),
      predefinedItems: List<String>.from(map['predefinedItems'] ?? []),
      allowPlusOne: map['allowPlusOne'] as bool? ?? true, // NOVO: Lê do mapa, padrão para true
    );
  }
}