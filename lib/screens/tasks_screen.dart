/**
 * @project Party Planner
 * @module Checklist de tarefas
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

// lib/screens/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/models/party_task.dart';
import 'package:party_planner/screens/home_tab.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/services/task_service.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';
import 'package:party_planner/widgets/pill_widgets.dart';

/// Filtros da lista de tarefas.
enum TaskFilter { urgentes, aFazer, feitas }

/// Cor do status: urgente, a fazer ou feita.
Color taskColor(PartyTask task) {
  if (task.done) return AppColors.taskDone;
  return task.urgent ? AppColors.taskUrgent : AppColors.taskTodo;
}

/// Aba Tarefas: checklist do evento escolhido.
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Event?>(
      valueListenable: AppSession.instance.currentEvent,
      builder: (context, event, _) => event == null
          ? const _NoEventSelected()
          : _TaskList(key: ValueKey(event.id), event: event),
    );
  }
}

class _NoEventSelected extends StatelessWidget {
  const _NoEventSelected();

  @override
  Widget build(BuildContext context) {
    return PartyPage(
      title: 'Tarefas',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, kBottomBarSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Escolha um evento em Meus Eventos para ver as tarefas dele.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              PillButton(
                label: 'MEUS EVENTOS',
                onPressed: () => AppSession.instance.goTo(AppTab.inicio),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskList extends StatefulWidget {
  const _TaskList({super.key, required this.event});

  final Event event;

  @override
  State<_TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<_TaskList> {
  final TaskService _service = TaskService();
  TaskFilter? _filter;

  List<PartyTask> get _visibleTasks {
    final tasks = _service.tasksFor(widget.event.id);
    switch (_filter) {
      case null:
        return tasks;
      case TaskFilter.urgentes:
        return tasks.where((t) => t.urgent && !t.done).toList();
      case TaskFilter.aFazer:
        return tasks.where((t) => !t.urgent && !t.done).toList();
      case TaskFilter.feitas:
        return tasks.where((t) => t.done).toList();
    }
  }

  void _toggleDone(PartyTask task) {
    _service.updateTask(task.copyWith(done: !task.done));
    setState(() {});
  }

  void _showMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _deleteTask(PartyTask task) async {
    final ok = await showConfirmDialog(context, title: 'Excluir esta tarefa?');
    if (!ok || !mounted) return;
    _service.removeTask(task);
    setState(() {});
    _showMessage('Tarefa excluída.');
  }

  Future<void> _openTask(PartyTask task) async {
    final action = await showPartySheet<String>(
      context,
      builder: (context) => _TaskDetail(task: task),
    );
    if (!mounted) return;
    if (action == 'toggle') _toggleDone(task);
    if (action == 'delete') await _deleteTask(task);
  }

  Future<void> _clearDone() async {
    final hasDone = _service.tasksFor(widget.event.id).any((t) => t.done);
    if (!hasDone) {
      _showMessage('Nenhuma tarefa feita para limpar.');
      return;
    }
    final ok = await showConfirmDialog(context, title: 'Limpar as tarefas feitas?', confirmLabel: 'LIMPAR');
    if (!ok || !mounted) return;
    final removed = _service.removeDone(widget.event.id);
    setState(() {});
    _showMessage(removed == 1 ? '1 tarefa removida.' : '$removed tarefas removidas.');
  }

  Future<void> _addTask() async {
    final created = await showPartySheet<bool>(
      context,
      builder: (_) => _NewTaskForm(eventId: widget.event.id),
    );
    if (created == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _visibleTasks;

    return PartyPage(
      title: 'Tarefas · ${widget.event.title}',
      onBack: () => AppSession.instance.goTo(AppTab.inicio),
      actions: [
        IconButton(
          tooltip: 'Limpar tarefas feitas',
          icon: const Icon(Icons.cleaning_services_outlined, color: Colors.white),
          onPressed: _clearDone,
        ),
      ],
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final (filter, label, color) in const [
                  (TaskFilter.urgentes, 'Urgentes', AppColors.taskUrgent),
                  (TaskFilter.aFazer, 'A fazer', AppColors.taskTodo),
                  (TaskFilter.feitas, 'Feitas', AppColors.taskDone),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = _filter == filter ? null : filter),
                      showCheckmark: false,
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.ground,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      avatar: CircleAvatar(radius: 6, backgroundColor: color),
                      label: Text(
                        label,
                        style: TextStyle(
                          color: _filter == filter ? Colors.white : AppColors.ground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, kBottomBarSpace),
              children: [
                if (tasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Nenhuma tarefa aqui.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                for (final task in tasks)
                  _TaskTile(
                    task: task,
                    onToggle: () => _toggleDone(task),
                    onOpen: () => _openTask(task),
                  ),
                const SizedBox(height: 8),
                Center(child: PillButton(label: 'NOVA TAREFA', onPressed: _addTask)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.onToggle, required this.onOpen});

  final PartyTask task;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final color = taskColor(task);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: const Color(0x33000000),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6, color: color),
                Checkbox(
                  value: task.done,
                  onChanged: (_) => onToggle(),
                  activeColor: color,
                  side: BorderSide(color: color, width: 2),
                  semanticLabel: task.done ? 'Marcar como não feita' : 'Marcar como feita',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: task.done ? Colors.black45 : AppColors.ground,
                            fontWeight: FontWeight.w700,
                            decoration: task.done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        if (task.description.isNotEmpty)
                          Text(
                            task.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ),
                if (task.urgent && !task.done)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.priority_high, color: color, semanticLabel: 'Urgente'),
                  )
                else
                  const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Detalhe da tarefa na folha branca: devolve 'toggle' ou 'delete'.
class _TaskDetail extends StatelessWidget {
  const _TaskDetail({required this.task});

  final PartyTask task;

  @override
  Widget build(BuildContext context) {
    final color = taskColor(task);
    final status = task.done ? 'Feita' : (task.urgent ? 'Urgente' : 'A fazer');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 6, backgroundColor: color),
            const SizedBox(width: 8),
            Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          task.title,
          style: const TextStyle(color: AppColors.ground, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Text(
          task.description.isEmpty ? 'Sem descrição.' : task.description,
          style: const TextStyle(color: Colors.black87, height: 1.5),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop('delete'),
              style: TextButton.styleFrom(foregroundColor: AppColors.accent),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Excluir'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop('toggle'),
              child: Text(task.done ? 'REABRIR' : 'MARCAR COMO FEITA'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Formulário de nova tarefa, com erro quando o nome fica vazio.
class _NewTaskForm extends StatefulWidget {
  const _NewTaskForm({required this.eventId});

  final String eventId;

  @override
  State<_NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<_NewTaskForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _urgent = false;
  String? _titleError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = 'Dê um nome para a tarefa.');
      return;
    }
    TaskService().addTask(
      widget.eventId,
      title: title,
      description: _descriptionController.text.trim(),
      urgent: _urgent,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Nova tarefa',
          style: TextStyle(color: AppColors.ground, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          autofocus: true,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: 'Tarefa', errorText: _titleError),
          onChanged: (_) {
            if (_titleError != null) setState(() => _titleError = null);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Detalhes (opcional)'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Urgente'),
          value: _urgent,
          activeThumbColor: AppColors.taskUrgent,
          onChanged: (value) => setState(() => _urgent = value),
        ),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _save, child: const Text('SALVAR')),
      ],
    );
  }
}
