// lib/screens/event_creation_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/services/notification_service.dart';

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  State<EventCreationScreen> createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _predefinedItemController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();

  ItemContributionOption _selectedContributionOption = ItemContributionOption.guestChooses;
  final List<String> _predefinedItems = [];
  bool _allowPlusOne = true; // NOVO: Estado do switch para permitir acompanhantes

  final EventService _eventService = EventService();
  final NotificationService _notificationService = NotificationService();

  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDateTime) {
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (pickedTime != null && pickedTime != TimeOfDay.fromDateTime(_selectedDateTime)) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _addPredefinedItem() {
    final itemName = _predefinedItemController.text.trim();
    if (itemName.isNotEmpty && !_predefinedItems.contains(itemName)) {
      setState(() {
        _predefinedItems.add(itemName);
        _predefinedItemController.clear();
      });
    } else if (itemName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite um nome para o item.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este item já está na lista.')),
      );
    }
  }

  void _removePredefinedItem(String item) {
    setState(() {
      _predefinedItems.remove(item);
    });
  }

  Future<void> _createEvent() async {
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios.')),
      );
      return;
    }

    if (_selectedContributionOption == ItemContributionOption.predefinedList && _predefinedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, adicione itens à lista pré-definida.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      location: _locationController.text,
      date: _selectedDateTime,
      description: _descriptionController.text,
      hostId: 'current_user_id_simulado',
      contributionOption: _selectedContributionOption,
      predefinedItems: _predefinedItems,
      allowPlusOne: _allowPlusOne, // NOVO: Passa o valor do switch
    );

    bool success = await _eventService.createEvent(newEvent);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      _notificationService.scheduleEventReminder(
        newEvent,
        'Seu evento "${newEvent.title}" se aproxima!',
        const Duration(days: 1),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento criado com sucesso! Lembrete agendado.')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao criar o evento. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Novo Evento'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título do Evento',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Local',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text('Data: ${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.grey)),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text('Hora: ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.grey)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // NOVO: Switch para permitir ou não acompanhantes (+1)
                  SwitchListTile(
                    title: const Text('Permitir Convidados levarem Acompanhantes (+1)'),
                    value: _allowPlusOne,
                    onChanged: (bool newValue) {
                      setState(() {
                        _allowPlusOne = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  const Text('Opções de Contribuição de Itens:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ItemContributionOption>(
                    value: _selectedContributionOption,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Escolha uma opção',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: ItemContributionOption.predefinedList,
                        child: Text('1. O anfitrião faz uma lista'),
                      ),
                      DropdownMenuItem(
                        value: ItemContributionOption.none,
                        child: Text('2. Não precisa levar nada'),
                      ),
                      DropdownMenuItem(
                        value: ItemContributionOption.guestChooses,
                        child: Text('3. O convidado pode escolher algo para levar'),
                      ),
                    ],
                    onChanged: (ItemContributionOption? newValue) {
                      setState(() {
                        _selectedContributionOption = newValue!;
                        if (newValue != ItemContributionOption.predefinedList) {
                          _predefinedItems.clear();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  if (_selectedContributionOption == ItemContributionOption.predefinedList)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Itens Pré-definidos para a Lista:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _predefinedItemController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome do Item',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (_) => _addPredefinedItem(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _addPredefinedItem,
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _predefinedItems.isEmpty
                            ? const Text('Nenhum item adicionado ainda.', style: TextStyle(fontStyle: FontStyle.italic))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _predefinedItems.length,
                                itemBuilder: (context, index) {
                                  final item = _predefinedItems[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      title: Text(item),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                        onPressed: () => _removePredefinedItem(item),
                                      ),
                                    ),
                                  );
                                },
                              ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  ElevatedButton(
                    onPressed: _createEvent,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Criar Evento', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
    );
  }
}