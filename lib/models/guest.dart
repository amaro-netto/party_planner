// lib/models/guest.dart

// Um modelo para representar um Convidado em um evento.
class Guest {
  final String id; // ID único do convidado (no futuro, pode ser do Firebase Auth ID ou gerado)
  final String name; // Nome do convidado
  final String email; // Email do convidado
  bool isAttending; // Status de confirmação (vai ou não vai)
  int plusOneCount; // Quantidade de acompanhantes
  String? itemBringing; // Item que o convidado se comprometeu a levar (opcional)

  // Construtor.
  Guest({
    required this.id,
    required this.name,
    required this.email,
    this.isAttending = false, // Padrão: não confirmado inicialmente
    this.plusOneCount = 0,    // Padrão: nenhum acompanhante
    this.itemBringing,        // Inicialmente nulo
  });

  // Método para converter Guest para um mapa (útil para salvar no DB).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAttending': isAttending,
      'plusOneCount': plusOneCount,
      'itemBringing': itemBringing,
    };
  }

  // Método para criar um objeto Guest a partir de um mapa (útil para carregar do DB).
  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isAttending: map['isAttending'] as bool,
      plusOneCount: map['plusOneCount'] as int,
      itemBringing: map['itemBringing'] as String?,
    );
  }
}