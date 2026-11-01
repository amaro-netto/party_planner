/**
 * @project Party Planner
 * @module Modelos de dados
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

// lib/models/guest.dart

// Um modelo para representar um Convidado em um evento.
class Guest {
  final String id;
  final String name;
  final String email;
  bool isAttending;
  int plusOneCount;
  String? itemBringing;

  // Construtor.
  Guest({
    required this.id,
    required this.name,
    required this.email,
    this.isAttending = false,
    this.plusOneCount = 0,
    this.itemBringing,
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