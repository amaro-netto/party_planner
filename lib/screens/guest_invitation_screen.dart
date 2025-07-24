// lib/screens/guest_invitation_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/models/guest.dart';
import 'package:party_planner/services/event_service.dart';

class GuestInvitationScreen extends StatefulWidget {
  final Event event;
  final Guest? guest;

  const GuestInvitationScreen({required this.event, this.guest, super.key});

  @override
  State<GuestInvitationScreen> createState() => _GuestInvitationScreenState();
}

class _GuestInvitationScreenState extends State<GuestInvitationScreen> {
  final EventService _eventService = EventService();
  late Guest _currentGuest;

  final TextEditingController _guestItemBringingController = TextEditingController();

  int _plusOneCount = 0;
  String? _selectedGuestChosenItem;
  bool _isLoading = false; // NOVO: Variável de carregamento para esta tela

  @override
  void initState() {
    super.initState();
    if (widget.guest != null) {
      _currentGuest = widget.guest!;
    } else {
      _currentGuest = Guest(
        id: 'guest_simulado_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Convidado Teste',
        email: 'convidado.teste@email.com',
        isAttending: false,
        plusOneCount: 0,
        itemBringing: '',
      );
      // Adiciona este convidado simulado ao evento no EventService (para que o anfitrião o veja)
      _eventService.addGuestToEvent(widget.event.id, _currentGuest);
    }

    _plusOneCount = _currentGuest.plusOneCount;
    _guestItemBringingController.text = _currentGuest.itemBringing ?? '';
    _selectedGuestChosenItem = _currentGuest.itemBringing;
  }

  Future<void> _handleRsvp(bool willAttend) async {
    setState(() { _isLoading = true; }); // Ativa carregamento
    _currentGuest.isAttending = willAttend;
    if (!willAttend) {
      _plusOneCount = 0;
      _guestItemBringingController.clear();
      _selectedGuestChosenItem = null;
      _currentGuest.plusOneCount = 0;
      _currentGuest.itemBringing = null;
    }
    await _updateGuestStatus();
    setState(() { _isLoading = false; }); // Desativa carregamento

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sua presença foi ${willAttend ? 'confirmada' : 'cancelada'}!')),
    );
  }

  void _updatePlusOneCount(int change) async {
    setState(() { _isLoading = true; }); // Ativa carregamento
    _plusOneCount = (_plusOneCount + change).clamp(0, 10);
    _currentGuest.plusOneCount = _plusOneCount;
    await _updateGuestStatus();
    setState(() { _isLoading = false; }); // Desativa carregamento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Acompanhantes atualizados para $_plusOneCount.')),
    );
  }

  Future<void> _submitGuestChosenItem() async {
    if (_guestItemBringingController.text.trim().isEmpty) { // Validação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite o item que você vai trazer.')),
      );
      return;
    }
    setState(() { _isLoading = true; }); // Ativa carregamento
    _currentGuest.itemBringing = _guestItemBringingController.text.trim();
    await _updateGuestStatus();
    setState(() { _isLoading = false; }); // Desativa carregamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sua contribuição foi registrada!')),
    );
    FocusScope.of(context).unfocus(); // Esconde o teclado
  }

  Future<void> _selectPredefinedItem(String? item) async {
    setState(() { _isLoading = true; }); // Ativa carregamento
    _selectedGuestChosenItem = item;
    _currentGuest.itemBringing = item;
    await _updateGuestStatus();
    setState(() { _isLoading = false; }); // Desativa carregamento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você selecionou: ${item ?? 'Nada'}')),
    );
  }

  Future<void> _updateGuestStatus() async {
    bool success = await _eventService.updateGuest(widget.event.id, _currentGuest);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao atualizar seu status. Tente novamente.')),
      );
    }
  }

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
      body: _isLoading // Exibe um CircularProgressIndicator se estiver carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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

                  const Text(
                    'Você vai comparecer?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _currentGuest.isAttending || _isLoading ? null : () => _handleRsvp(true), // Desabilita se já confirmado ou carregando
                        icon: const Icon(Icons.check_circle),
                        label: Text(_currentGuest.isAttending ? 'Confirmado!' : 'Sim, vou!'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentGuest.isAttending ? Colors.green : Colors.grey,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: !_currentGuest.isAttending || _isLoading ? null : () => _handleRsvp(false), // Desabilita se já negado ou carregando
                        icon: const Icon(Icons.cancel),
                        label: Text(!_currentGuest.isAttending ? 'Não vou.' : 'Desistir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_currentGuest.isAttending ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

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
                              onPressed: _plusOneCount > 0 && !_isLoading ? () => _updatePlusOneCount(-1) : null, // Desabilita se carregando
                            ),
                            Text(
                              '$_plusOneCount',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, size: 30),
                              onPressed: !_isLoading ? () => _updatePlusOneCount(1) : null, // Desabilita se carregando
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    )
                  else if (_currentGuest.isAttending && !widget.event.allowPlusOne)
                    const Column(
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
                                value: _selectedGuestChosenItem ?? (widget.event.predefinedItems.isNotEmpty ? widget.event.predefinedItems.first : null),
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
                                onChanged: _isLoading ? null : _selectPredefinedItem, // Desabilita enquanto carrega
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
                                onSubmitted: (_) => _submitGuestChosenItem(),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitGuestChosenItem, // Desabilita enquanto carrega
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