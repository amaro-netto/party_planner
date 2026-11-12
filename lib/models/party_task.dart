/**
 * @project Party Planner
 * @module Tarefas do evento
 * @author amaro-netto / Amaro Amarante da Silva Netto
 * @contact contato@amaronetto.com.br
 * @date 12/11/2026
 *
 * SOBRE OS DIREITOS AUTORAIS:
 * A arquitetura, design estrutural e desenvolvimento deste software foram
 * realizados pelo autor supracitado. Os direitos patrimoniais e de licença
 * de uso pertencem ao próprio autor, Amaro Amarante da Silva Netto.
 *
 * Ficam resguardados os direitos morais do autor original, sendo vedada a
 * remoção deste aviso de autoria do código-fonte (Lei 9.609/1998).
 */

// lib/models/party_task.dart

/// Tarefa do checklist de um evento.
///
/// A cor na tela vem do estado: concluída (verde), urgente (vermelho) ou
/// pendente (amarelo), como definido no estudo de usabilidade.
class PartyTask {
  final String id;
  final String eventId;
  final String title;
  final String description;
  final bool urgent;
  final bool done;

  const PartyTask({
    required this.id,
    required this.eventId,
    required this.title,
    this.description = '',
    this.urgent = false,
    this.done = false,
  });

  PartyTask copyWith({String? title, String? description, bool? urgent, bool? done}) {
    return PartyTask(
      id: id,
      eventId: eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      urgent: urgent ?? this.urgent,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'eventId': eventId,
        'title': title,
        'description': description,
        'urgent': urgent,
        'done': done,
      };

  factory PartyTask.fromMap(Map<String, dynamic> map) => PartyTask(
        id: map['id'] as String,
        eventId: map['eventId'] as String,
        title: map['title'] as String,
        description: map['description'] as String? ?? '',
        urgent: map['urgent'] as bool? ?? false,
        done: map['done'] as bool? ?? false,
      );
}
