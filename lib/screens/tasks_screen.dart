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
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/services/task_service.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';

/// Filtros do topo da lista ("Urgentes", "Pendentes", "Concluídas").
enum TaskFilter { urgentes, pendentes, concluidas }

/// Cor de cada tarefa conforme o estudo de usabilidade.
Color taskColor(PartyTask task) {
  if (task.done) return AppColors.done;
  return task.urgent ? AppColors.urgent : AppColors.pending;
}

/// Aba Tarefas: checklist do evento selecionado.
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
    return InnerBackground(
      child: Column(
        children: [
          const CoralHeader(title: 'Tarefas a fazer', icon: Icons.format_list_bulleted),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.checklist, size: 64, color: AppColors.headerCoral),
                    const SizedBox(height: 12),
                    const Text(
                      'Escolha um evento na aba Início para ver a lista de tarefas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.text, fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => AppSession.instance.goTo(AppTab.inicio),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.headerCoral),
                      child: const Text('Ir para Início'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      case TaskFilter.pendentes:
        return tasks.where((t) => !t.urgent && !t.done).toList();
      case TaskFilter.concluidas:
        return tasks.where((t) => t.done).toList();
    }
  }

  void _toggleFilter(TaskFilter filter) =>
      setState(() => _filter = _filter == filter ? null : filter);

  void _toggleDone(PartyTask task) {
    _service.updateTask(task.copyWith(done: !task.done));
    setState(() {});
  }

  void _showMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _openTask(PartyTask task) async {
    final action = await showDialog<_TaskAction>(
      context: context,
      builder: (_) => _TaskDetailDialog(task: task),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case _TaskAction.toggleDone:
        _toggleDone(task);
      case _TaskAction.delete:
        _service.removeTask(task);
        setState(() {});
        _showMessage('Tarefa excluída.');
    }
  }

  Future<void> _removeDone() async {
    final hasDone = _service.tasksFor(widget.event.id).any((t) => t.done);
    if (!hasDone) {
      _showMessage('Nenhuma tarefa concluída para apagar.');
      return;
    }
    final ok = await showConfirmDialog(context, 'Tem certeza que deseja deletar as tarefas concluídas?');
    if (!ok || !mounted) return;
    final removed = _service.removeDone(widget.event.id);
    setState(() {});
    _showMessage(removed == 1 ? '1 tarefa removida.' : '$removed tarefas removidas.');
  }

  Future<void> _addTask() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => _NewTaskDialog(eventId: widget.event.id),
    );
    if (created == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _visibleTasks;

    return InnerBackground(
      child: Column(
        children: [
          CoralHeader(
            title: 'Tarefas a fazer',
            icon: Icons.format_list_bulleted,
            onBack: () => AppSession.instance.goTo(AppTab.inicio),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Urgentes',
                  icon: Icons.timer_outlined,
                  color: AppColors.urgent,
                  selected: _filter == TaskFilter.urgentes,
                  dimmed: _filter != null && _filter != TaskFilter.urgentes,
                  onTap: () => _toggleFilter(TaskFilter.urgentes),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pendentes',
                  color: AppColors.pending,
                  selected: _filter == TaskFilter.pendentes,
                  dimmed: _filter != null && _filter != TaskFilter.pendentes,
                  onTap: () => _toggleFilter(TaskFilter.pendentes),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Concluídas',
                  color: AppColors.done,
                  selected: _filter == TaskFilter.concluidas,
                  dimmed: _filter != null && _filter != TaskFilter.concluidas,
                  onTap: () => _toggleFilter(TaskFilter.concluidas),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma tarefa aqui.',
                      style: TextStyle(color: AppColors.textSoft),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    itemCount: tasks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _TaskCard(
                      task: tasks[index],
                      onToggle: () => _toggleDone(tasks[index]),
                      onOpen: () => _openTask(tasks[index]),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Apagar tarefas concluídas',
                  iconSize: 32,
                  icon: const Icon(Icons.delete_outline, color: AppColors.headerCoral),
                  onPressed: _removeDone,
                ),
                const Spacer(),
                AddFab(tooltip: 'Nova tarefa', onPressed: _addTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.dimmed,
    required this.onTap,
    this.icon,
  });

  final String label;
  final Color color;
  final bool selected;
  final bool dimmed;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        child: Opacity(
          opacity: dimmed ? 0.45 : 1,
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: selected ? Colors.white : Colors.transparent, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 4),
                      Icon(icon, size: 14, color: Colors.white),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.onToggle, required this.onOpen});

  final PartyTask task;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final color = taskColor(task);
    final subtitle = task.description.isEmpty
        ? 'Preparar...'
        : task.description.split(RegExp(r'[.\n]')).first;

    return SoftCard(
      onTap: onOpen,
      padding: const EdgeInsets.fromLTRB(6, 10, 8, 10),
      child: Row(
        children: [
          Semantics(
            label: task.done ? 'Marcar como não concluída' : 'Marcar como concluída',
            child: InkResponse(
              onTap: onToggle,
              radius: 22,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: task.done ? color.withValues(alpha: 0.12) : null,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: task.done ? Icon(Icons.check, size: 16, color: color) : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    decoration: task.done ? TextDecoration.lineThrough : null,
                    decorationColor: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSoft, fontSize: 12),
                ),
              ],
            ),
          ),
          if (task.urgent && !task.done)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(Icons.timer_outlined, color: color, semanticLabel: 'Urgente'),
            ),
          Icon(Icons.chevron_right, color: color),
        ],
      ),
    );
  }
}

enum _TaskAction { toggleDone, delete }

/// Detalhe da tarefa: descrição, lixeira e botão "Concluído".
class _TaskDetailDialog extends StatelessWidget {
  const _TaskDetailDialog({required this.task});

  final PartyTask task;

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showConfirmDialog(context, 'Tem certeza que deseja deletar a tarefa?');
    if (ok && context.mounted) Navigator.of(context).pop(_TaskAction.delete);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Fechar',
                icon: const Icon(Icons.close, color: AppColors.text),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    task.description.isEmpty ? 'Sem descrição.' : task.description,
                    style: const TextStyle(color: AppColors.text, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Excluir tarefa',
                        icon: const Icon(Icons.delete_outline, color: AppColors.headerCoral),
                        onPressed: () => _confirmDelete(context),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(_TaskAction.toggleDone),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: task.done ? AppColors.pending : AppColors.headerCoral,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                        ),
                        child: Text(task.done ? 'Reabrir' : 'Concluído'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formulário de nova tarefa, com mensagem de erro no título vazio.
class _NewTaskDialog extends StatefulWidget {
  const _NewTaskDialog({required this.eventId});

  final String eventId;

  @override
  State<_NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<_NewTaskDialog> {
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
    return AlertDialog(
      backgroundColor: AppColors.cream,
      title: const Text('Nova tarefa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Descrição (opcional)'),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Urgente'),
              value: _urgent,
              activeThumbColor: AppColors.urgent,
              onChanged: (value) => setState(() => _urgent = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.headerCoral),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
