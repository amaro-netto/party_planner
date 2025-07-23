// lib/screens/event_creation_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart'; // Importa o modelo de Evento
import 'package:party_planner/services/event_service.dart'; // Importa o serviço de Eventos

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  State<EventCreationScreen> createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  // Controladores para os campos de texto do formulário.
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Variável para armazenar a data e hora selecionadas.
  DateTime _selectedDateTime = DateTime.now();

  // Instância do nosso serviço de eventos.
  final EventService _eventService = EventService();

  // Variável para controlar o estado de carregamento durante a criação.
  bool _isLoading = false;

  // Método para abrir o seletor de data.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(), // Não pode selecionar data no passado.
      lastDate: DateTime(2101), // Data limite no futuro.
    );
    if (pickedDate != null && pickedDate != _selectedDateTime) {
      setState(() {
        // Atualiza apenas a data, mantendo o horário se já selecionado.
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

  // Método para abrir o seletor de hora.
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (pickedTime != null && pickedTime != TimeOfDay.fromDateTime(_selectedDateTime)) {
      setState(() {
        // Atualiza apenas o horário, mantendo a data.
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

  // Método para criar o evento.
  Future<void> _createEvent() async {
    // Validação básica para garantir que os campos importantes não estão vazios.
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Ativa o carregamento.
    });

    // Cria um novo objeto Event com os dados do formulário.
    // O 'id' e 'hostId' são simulados por enquanto. No futuro, seriam gerados pelo backend.
    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID único baseado no timestamp.
      title: _titleController.text,
      location: _locationController.text,
      date: _selectedDateTime,
      description: _descriptionController.text,
      hostId: 'current_user_id_simulado', // ID do anfitrião simulado.
    );

    // Chama o serviço para criar o evento.
    bool success = await _eventService.createEvent(newEvent);

    setState(() {
      _isLoading = false; // Desativa o carregamento.
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento criado com sucesso!')),
      );
      Navigator.pop(context, true); // Volta para a tela anterior (Dashboard), passando 'true' para indicar sucesso.
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
          ? const Center(child: CircularProgressIndicator()) // Mostra carregamento se estiver criando
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Estica os elementos horizontalmente
                children: <Widget>[
                  // Campo Título do Evento
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título do Evento',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Campo Local
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Local',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Seleção de Data
                  ListTile(
                    title: Text('Data: ${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context), // Abre o seletor de data
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.grey)), // Borda para o ListTile
                  ),
                  const SizedBox(height: 16),
                  // Seleção de Hora
                  ListTile(
                    title: Text('Hora: ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => _selectTime(context), // Abre o seletor de hora
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.grey)),
                  ),
                  const SizedBox(height: 16),
                  // Campo Descrição
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3, // Permite múltiplas linhas para a descrição
                  ),
                  const SizedBox(height: 24),
                  // Botão Criar Evento
                  ElevatedButton(
                    onPressed: _createEvent, // Chama o método _createEvent ao pressionar
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