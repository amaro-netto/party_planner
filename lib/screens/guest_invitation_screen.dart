// lib/screens/guest_invitation_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart'; // Importa o modelo Evento
import 'package:party_planner/models/guest.dart'; // Importa o modelo Convidado
import 'package:party_planner/services/event_service.dart'; // Importa o EventService
// Removidos imports não utilizados: Item e Collection.

class GuestInvitationScreen extends StatefulWidget {
  final Event event; // O evento para o qual o convidado foi convidado.
  final Guest? guest; // O objeto Guest correspondente ao convidado (pode ser nulo se for um link genérico)

  const GuestInvitationScreen({required this.event, this.guest, super.key});

  @override
  State<GuestInvitationScreen> createState() => _GuestInvitationScreenState();
}

class _GuestInvitationScreenState extends State<GuestInvitationScreen> {
  final EventService _eventService = EventService();
  late Guest _currentGuest; // O convidado que está visualizando o convite

  // Controladores para o campo "o que você vai trazer?"
  final TextEditingController _guestItemBringingController = TextEditingController();

  // Variável para a contagem de acompanhantes
  int _plusOneCount = 0;
  // Variável para a escolha de item para GuestChooses
  String? _selectedGuestChosenItem;


  @override
  void initState() {
    super.initState();
    // Inicializa _currentGuest. Se já tem um guest, usa ele. Senão, cria um mock.
    if (widget.guest != null) {
      _currentGuest = widget.guest!;
    } else {
      // Simulando um convidado se o acesso for por um link genérico sem guestId
      _currentGuest = Guest(
        id: 'guest_simulado_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Convidado Teste',
        email: 'convidado.teste@email.com',
        isAttending: false,
        plusOneCount: 0,
        itemBringing: '',
      );
      // Opcional: Adicionar este convidado simulado ao evento no EventService
      _eventService.addGuestToEvent(widget.event.id, _currentGuest);
    }

    // Inicializa os estados com os valores atuais do convidado
    _plusOneCount = _currentGuest.plusOneCount;
    _guestItemBringingController.text = _currentGuest.itemBringing ?? '';
    _selectedGuestChosenItem = _currentGuest.itemBringing; // Inicializa a seleção do dropdown
  }

  // Método para processar a confirmação de presença (RSVP)
  Future<void> _handleRsvp(bool willAttend) async {
    setState(() {
      _currentGuest.isAttending = willAttend; // Atualiza o status
      if (!willAttend) { // Se não vai, zera acompanhantes e item
        _plusOneCount = 0;
        _guestItemBringingController.clear();
        _selectedGuestChosenItem = null;
        _currentGuest.plusOneCount = 0;
        _currentGuest.itemBringing = null;
      }
    });
    await _updateGuestStatus();
  }

  // Método para atualizar o número de acompanhantes
  void _updatePlusOneCount(int change) async {
    setState(() {
      _plusOneCount = (_plusOneCount + change).clamp(0, 10); // Limita entre 0 e 10
      _currentGuest.plusOneCount = _plusOneCount;
    });
    await _updateGuestStatus();
  }

  // Método para processar o item que o convidado escolheu (opção "guestChooses")
  Future<void> _submitGuestChosenItem() async {
    setState(() {
      _currentGuest.itemBringing = _guestItemBringingController.text.trim();
    });
    await _updateGuestStatus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sua contribuição foi registrada!')),
    );
  }

  // Método para processar a seleção de item da lista pré-definida (opção "predefinedList")
  Future<void> _selectPredefinedItem(String? item) async {
    setState(() {
      _selectedGuestChosenItem = item;
      _currentGuest.itemBringing = item;
    });
    await _updateGuestStatus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você selecionou: ${item ?? 'Nada'}')),
    );
  }

  // Método auxiliar para atualizar o convidado no serviço.
  Future<void> _updateGuestStatus() async {
    bool success = await _eventService.updateGuest(widget.event.id, _currentGuest);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao atualizar seu status. Tente novamente.')),
      );
    }
  }

  // Método para obter a descrição da opção de contribuição
  String _getContributionOptionDescription(ItemContributionOption option) {
    switch (option) {
      case ItemContributionOption.predefinedList:
        return 'O anfitrião fez uma lista do que precisa. Por favor, escolha um item.';
      case ItemContributionOption.none:
        return 'O anfitrião informou que VOCÊ NÃO PRECISA LEVAR NADA.';
      case ItemContributionOption.guestChooses:
        return 'Você pode ESCOLHER livremente o que levar para a festa.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ItemContributionOption currentOption = widget.event.contributionOption;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Convite'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Detalhes do Evento
            Text(
              widget.event.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              widget.event.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Local: ${widget.event.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Quando: ${widget.event.date.day}/${widget.event.date.month}/${widget.event.date.year} às ${widget.event.date.hour.toString().padLeft(2, '0')}:${widget.event.date.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Seção RSVP (Confirmação de Presença)
            const Text(
              'Você vai comparecer?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentGuest.isAttending ? null : () => _handleRsvp(true),
                  icon: const Icon(Icons.check_circle),
                  label: Text(_currentGuest.isAttending ? 'Confirmado!' : 'Sim, vou!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentGuest.isAttending ? Colors.green : Colors.grey,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: !_currentGuest.isAttending ? null : () => _handleRsvp(false),
                  icon: const Icon(Icons.cancel),
                  label: Text(!_currentGuest.isAttending ? 'Não vou.' : 'Desistir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_currentGuest.isAttending ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Seção Acompanhantes (visível apenas se o convidado confirmar presença E o anfitrião permitir)
            if (_currentGuest.isAttending && widget.event.allowPlusOne)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quantas pessoas você vai levar?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 30),
                        onPressed: _plusOneCount > 0 ? () => _updatePlusOneCount(-1) : null,
                      ),
                      Text(
                        '$_plusOneCount',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 30),
                        onPressed: () => _updatePlusOneCount(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              )
            // AQUI ESTÁ A CORREÇÃO DE SINTAXE. O 'else if' precisa de um corpo de widget.
            // Coloquei a mensagem dentro de um `Column` para ser mais explícito,
            // embora um `Padding` diretamente já funcione.
            else if (_currentGuest.isAttending && !widget.event.allowPlusOne)
              const Column( // Adicionei Column para garantir que o widget é bem formado
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'O anfitrião não permite convidados adicionais para este evento.',
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ),
                ],
              ),

            // Seção Contribuição de Itens
            const Text(
              'Contribuição de Itens:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getContributionOptionDescription(currentOption),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Lógica para exibir a interface de contribuição baseada na opção do anfitrião
            if (_currentGuest.isAttending)
              Builder(
                builder: (context) {
                  if (currentOption == ItemContributionOption.predefinedList) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Escolha um item da lista do anfitrião:', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedGuestChosenItem ?? (widget.event.predefinedItems.isNotEmpty ? widget.event.predefinedItems.first : null), // Correção para firstOrNull
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Item a trazer',
                          ),
                          items: widget.event.predefinedItems.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: _selectPredefinedItem,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else if (currentOption == ItemContributionOption.guestChooses) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('O que você gostaria de trazer?', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _guestItemBringingController,
                          decoration: const InputDecoration(
                            labelText: 'Ex: Refrigerante, Salada de Batata',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _submitGuestChosenItem,
                          child: const Text('Confirmar Item'),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else { // ItemContributionOption.none
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Que ótimo! O anfitrião não precisa que você leve nada.', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                    );
                  }
                },
              ),
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}