// lib/models/event.dart

// Um modelo simples para representar um Evento no PartyPlanner.
class Event {
  // Propriedades de um evento. Usamos 'final' porque esses valores
  // geralmente não mudam depois que o evento é criado.
  final String id;
  final String title;
  final String location;
  final DateTime date;
  final String description;
  final String hostId; // O ID do usuário que criou o evento (anfitrião)

  // Construtor da classe Event.
  // O 'required' significa que esses campos devem ser fornecidos ao criar um Evento.
  const Event({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
    required this.hostId,
  });

  // Um método (opcional, mas útil) para converter um Evento em um mapa de dados.
  // Isso é útil para salvar dados em um banco de dados como o Firestore no futuro.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'date': date.toIso8601String(), // Converte a data para string para armazenamento
      'description': description,
      'hostId': hostId,
    };
  }

  // Um método (opcional, mas útil) para criar um objeto Event a partir de um mapa de dados.
  // Isso é útil para carregar dados de um banco de dados.
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      location: map['location'] as String,
      date: DateTime.parse(map['date'] as String), // Converte a string de volta para DateTime
      description: map['description'] as String,
      hostId: map['hostId'] as String,
    );
  }
}