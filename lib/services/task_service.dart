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

// lib/services/task_service.dart
import 'package:party_planner/models/party_task.dart';

/// Checklist de tarefas por evento, em memória (simulado).
///
/// Na primeira vez que um evento é aberto, gera a lista padrão de tarefas
/// para o anfitrião acompanhar e editar.
class TaskService {
  TaskService._internal();
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;

  final Map<String, List<PartyTask>> _tasksByEvent = {};
  int _nextId = 1;

  static const List<(String, String, bool)> _defaultTasks = [
    ('Fazer lista de convidados', 'Preparar a lista com nome e contato de quem vai ser convidado.', true),
    ('Definir o orçamento', 'Preparar quanto pode ser gasto com local, comida, bebida e decoração.', true),
    ('Reservar o local', 'Preparar a reserva e confirmar data, horário e capacidade.', false),
    ('Contratar o buffet', 'Preparar orçamentos com pelo menos dois fornecedores.', false),
    ('Escolher a decoração', 'Preparar tema, cores e itens de decoração.', false),
    ('Enviar os convites', 'Preparar o link de convite e enviar para os convidados.', false),
  ];

  String _newId() => 'task${_nextId++}';

  /// Tarefas do evento. Cria o checklist padrão se ainda não existir.
  List<PartyTask> tasksFor(String eventId) {
    final tasks = _tasksByEvent.putIfAbsent(
      eventId,
      () => [
        for (final (title, description, urgent) in _defaultTasks)
          PartyTask(
            id: _newId(),
            eventId: eventId,
            title: title,
            description: description,
            urgent: urgent,
          ),
      ],
    );
    return List.unmodifiable(tasks);
  }

  PartyTask addTask(String eventId, {required String title, String description = '', bool urgent = false}) {
    tasksFor(eventId);
    final task = PartyTask(
      id: _newId(),
      eventId: eventId,
      title: title,
      description: description,
      urgent: urgent,
    );
    _tasksByEvent[eventId]!.add(task);
    return task;
  }

  void updateTask(PartyTask task) {
    final tasks = _tasksByEvent[task.eventId];
    if (tasks == null) return;
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) tasks[index] = task;
  }

  void removeTask(PartyTask task) {
    _tasksByEvent[task.eventId]?.removeWhere((t) => t.id == task.id);
  }

  /// Remove as concluídas e devolve quantas foram removidas.
  int removeDone(String eventId) {
    final tasks = _tasksByEvent[eventId];
    if (tasks == null) return 0;
    final before = tasks.length;
    tasks.removeWhere((t) => t.done);
    return before - tasks.length;
  }
}
