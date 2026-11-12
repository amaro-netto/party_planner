/**
 * @project Party Planner
 * @module Orçamento do evento
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


// lib/screens/budget_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';
import 'package:party_planner/widgets/pill_widgets.dart';

/// Gasto do orçamento de um evento.
class Expense {
  const Expense({required this.id, required this.name, required this.value});

  final String id;
  final String name;
  final double value;
}

/// Orçamento por evento, em memória (simulado).
class BudgetStore {
  BudgetStore._();
  static final BudgetStore instance = BudgetStore._();

  final Map<String, List<Expense>> _byEvent = {};
  int _nextId = 1;

  List<Expense> expensesFor(String eventId) => List.unmodifiable(_byEvent[eventId] ?? const []);

  void add(String eventId, String name, double value) {
    _byEvent.putIfAbsent(eventId, () => []).add(Expense(id: 'exp${_nextId++}', name: name, value: value));
  }

  void remove(String eventId, Expense expense) {
    _byEvent[eventId]?.removeWhere((e) => e.id == expense.id);
  }

  double total(String eventId) => expensesFor(eventId).fold<double>(0, (sum, e) => sum + e.value);
}

/// Lê "1.234,50", "1234.5" ou "80" como número.
double? parseMoney(String text) {
  var clean = text.replaceAll('R\$', '').replaceAll(' ', '').trim();
  if (clean.contains(',')) clean = clean.replaceAll('.', '').replaceAll(',', '.');
  final value = double.tryParse(clean);
  return value == null || value <= 0 ? null : value;
}

/// Orçamento do evento: total e lista de gastos.
class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key, required this.event});

  final Event event;

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final BudgetStore _store = BudgetStore.instance;

  Future<void> _addExpense() async {
    final added = await showPartySheet<bool>(
      context,
      builder: (_) => _ExpenseForm(eventId: widget.event.id),
    );
    if (added == true && mounted) setState(() {});
  }

  Future<void> _remove(Expense expense) async {
    final ok = await showConfirmDialog(context, title: 'Excluir "${expense.name}"?');
    if (!ok || !mounted) return;
    setState(() => _store.remove(widget.event.id, expense));
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _store.expensesFor(widget.event.id);

    return Scaffold(
      body: PartyPage(
        title: 'Orçamento',
        onBack: () => Navigator.of(context).pop(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.event.title, style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(
                      formatMoney(_store.total(widget.event.id)),
                      style: const TextStyle(color: AppColors.ground, fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                    const Text('total previsto', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SectionTitle('Gastos'),
            if (expenses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Nenhum gasto ainda. Adicione local, comida, bebida...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            for (final expense in expenses)
              PillRow(
                icon: Icons.receipt_long_outlined,
                label: expense.name,
                subtitle: formatMoney(expense.value),
                trailing: IconButton(
                  tooltip: 'Excluir gasto',
                  icon: const Icon(Icons.delete_outline, color: Colors.black45),
                  onPressed: () => _remove(expense),
                ),
              ),
            const SizedBox(height: 8),
            Center(child: PillButton(label: 'NOVO GASTO', onPressed: _addExpense)),
          ],
        ),
      ),
    );
  }
}

class _ExpenseForm extends StatefulWidget {
  const _ExpenseForm({required this.eventId});

  final String eventId;

  @override
  State<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<_ExpenseForm> {
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  String? _nameError;
  String? _valueError;

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final value = parseMoney(_valueController.text);
    setState(() {
      _nameError = name.isEmpty ? 'Informe o que é o gasto.' : null;
      _valueError = value == null ? 'Informe um valor maior que zero, ex.: 150,00' : null;
    });
    if (_nameError != null || _valueError != null) return;
    BudgetStore.instance.add(widget.eventId, name, value!);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Novo gasto',
          style: TextStyle(color: AppColors.ground, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          autofocus: true,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: 'Descrição', errorText: _nameError),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _valueController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (_) => _save(),
          decoration: InputDecoration(labelText: 'Valor (R\$)', errorText: _valueError),
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _save, child: const Text('SALVAR')),
      ],
    );
  }
}
