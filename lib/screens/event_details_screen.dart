// lib/screens/event_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para copiar para a área de transferência
import 'package:party_planner/models/event.dart';
import 'package:party_planner/models/guest.dart';
import 'package:party_planner/models/item.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/services/calculator_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({required this.event, super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventService _eventService = EventService();
  final CalculatorService _calculatorService = CalculatorService();
  late Future<List<Guest>> _guestsFuture;
  late Future<List<Item>> _itemsFuture;

  final TextEditingController _newGuestNameController = TextEditingController();
  final TextEditingController _newGuestEmailController = TextEditingController();

  final TextEditingController _newItemNameController = TextEditingController();
  final TextEditingController _newItemQuantityController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  void _loadEventData() {
    setState(() {
      _guestsFuture = _eventService.getGuestsForEvent(widget.event.id);
      _itemsFuture = _eventService.getItemsForEvent(widget.event.id);
    });
  }

  void _addNewGuest() async {
    if (_newGuestNameController.text.isEmpty || _newGuestEmailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome e Email do convidado são obrigatórios!')),
      );
      return;
    }

    final newGuest = Guest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _newGuestNameController.text,
      email: _newGuestEmailController.text,
    );

    bool success = await _eventService.addGuestToEvent(widget.event.id, newGuest);

    if (success) {
      _newGuestNameController.clear();
      _newGuestEmailController.clear();
      _loadEventData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Convidado adicionado com sucesso!')),
      );
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao adicionar convidado.')),
      );
    }
  }

  void _removeGuest(String guestId) async {
    bool success = await _eventService.removeGuestFromEvent(widget.event.id, guestId);
    if (success) {
      _loadEventData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Convidado removido com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao remover convidado.')),
      );
    }
  }

  void _addNewItemToCommittedList() async {
    if (_newItemNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome do item é obrigatório!')),
      );
      return;
    }

    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _newItemNameController.text,
      quantityNeeded: int.tryParse(_newItemQuantityController.text),
    );

    bool success = await _eventService.addOrUpdateCommittedItem(widget.event.id, newItem);

    if (success) {
      _newItemNameController.clear();
      _newItemQuantityController.clear();
      _loadEventData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item adicionado com sucesso!')),
      );
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao adicionar item.')),
      );
    }
  }

  void _removeItem(String itemId) async {
    bool success = await _eventService.removeItemFromEvent(widget.event.id, itemId);
    if (success) {
      _loadEventData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removido com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao remover item.')),
      );
    }
  }

  void _generateAndCopyInviteLink() async {
    final String inviteLink = 'http://localhost:9002/#/invite/${widget.event.id}';

    await Clipboard.setData(ClipboardData(text: inviteLink));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link do convite copiado para a área de transferência!')),
    );
    debugPrint('Link de Convite Gerado: $inviteLink');
  }


  Widget _buildGuestList() {
    return FutureBuilder<List<Guest>>(
      future: _guestsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar convidados: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum convidado adicionado ainda.'));
        } else {
          final guests = snapshot.data!;

          // CORREÇÃO: Usar 'isAttending'
          final int confirmedGuests = guests.where((g) => g.isAttending).length;
          final int totalPlusOnes = guests.where((g) => g.isAttending).fold(0, (sum, g) => sum + g.plusOneCount);
          final int totalAttendees = _calculatorService.calculateTotalAttendees(confirmedGuests, totalPlusOnes);

          final double estimatedBeverage = _calculatorService.calculateBeveragePerGuest(totalAttendees);
          final double estimatedMeat = _calculatorService.calculateMeatPerGuest(totalAttendees);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total de Convidados Confirmados: $confirmedGuests', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Total de Acompanhantes Confirmados: $totalPlusOnes', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Total de Pessoas Esperadas: $totalAttendees', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Estimativa de Bebida: ${estimatedBeverage.toStringAsFixed(1)} Litros', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Estimativa de Carne: ${estimatedMeat.toStringAsFixed(1)} KG', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: guests.length,
                itemBuilder: (context, index) {
                  final guest = guests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(guest.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(guest.email),
                          // CORREÇÃO: Usar 'isAttending'
                          Text('Vai? ${guest.isAttending ? 'Sim' : 'Não'}'),
                          if (guest.plusOneCount > 0)
                            Text('Acompanhantes: ${guest.plusOneCount}'),
                          if (guest.itemBringing != null && guest.itemBringing!.isNotEmpty)
                            Text('Trazendo: ${guest.itemBringing}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                // CORREÇÃO: Usar 'isAttending'
                                value: guest.isAttending,
                                onChanged: (bool? newValue) async {
                                  final updatedGuest = Guest(
                                    id: guest.id,
                                    name: guest.name,
                                    email: guest.email,
                                    isAttending: newValue!,
                                    plusOneCount: guest.plusOneCount,
                                    itemBringing: guest.itemBringing,
                                  );
                                  await _eventService.updateGuest(widget.event.id, updatedGuest);
                                  _loadEventData();
                                },
                              ),
                              if (widget.event.allowPlusOne)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: guest.plusOneCount > 0 ? () async {
                                        final updatedGuest = Guest(
                                          id: guest.id,
                                          name: guest.name,
                                          email: guest.email,
                                          isAttending: guest.isAttending,
                                          plusOneCount: guest.plusOneCount - 1,
                                          itemBringing: guest.itemBringing,
                                        );
                                        await _eventService.updateGuest(widget.event.id, updatedGuest);
                                        _loadEventData();
                                      } : null,
                                    ),
                                    Text('${guest.plusOneCount}'),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () async {
                                        final updatedGuest = Guest(
                                          id: guest.id,
                                          name: guest.name,
                                          email: guest.email,
                                          isAttending: guest.isAttending,
                                          plusOneCount: guest.plusOneCount + 1,
                                          itemBringing: guest.itemBringing,
                                        );
                                        await _eventService.updateGuest(widget.event.id, updatedGuest);
                                        _loadEventData();
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.red),
                            onPressed: () => _removeGuest(guest.id),
                          ),
                        ],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Editar detalhes de ${guest.name}')),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildCommittedItemList() {
    return FutureBuilder<List<Item>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar itens: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum item adicionado ainda.'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: item.quantityNeeded != null
                      ? Text('Quantidade Trazida: ${item.quantityNeeded}')
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(item.id),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildItemSummaryAndAnalysis() {
    return FutureBuilder<List<Item>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar totais de itens: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('Nenhum dado de item disponível.');
        } else {
          final List<Item> committedItems = snapshot.data!;
          return FutureBuilder<List<Guest>>(
            future: _guestsFuture,
            builder: (context, guestSnapshot) {
              if (guestSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (guestSnapshot.hasError) {
                return Text('Erro ao carregar convidados para análise: ${guestSnapshot.error}');
              } else if (!guestSnapshot.hasData) {
                return const Text('Nenhum dado de convidado disponível para análise.');
              } else {
                final List<Guest> guests = guestSnapshot.data!;
                final int confirmedGuests = guests.where((g) => g.isAttending).length;
                final int totalPlusOnes = guests.where((g) => g.isAttending).fold(0, (sum, g) => sum + g.plusOneCount);
                final int totalAttendees = _calculatorService.calculateTotalAttendees(confirmedGuests, totalPlusOnes);

                double committedBeverageLiters = 0.0;
                double committedMeatKg = 0.0;

                for (var item in committedItems) {
                  final lowerCaseName = item.name.toLowerCase();
                  if (item.quantityNeeded != null) {
                    if (lowerCaseName.contains('refrigerante') || lowerCaseName.contains('água') || lowerCaseName.contains('cerveja')) {
                      committedBeverageLiters += item.quantityNeeded!;
                    } else if (lowerCaseName.contains('carne') || lowerCaseName.contains('linguiça')) {
                      committedMeatKg += item.quantityNeeded!;
                    }
                  }
                }

                final double neededBeverageLiters = _calculatorService.calculateBeveragePerGuest(totalAttendees);
                final double neededMeatKg = _calculatorService.calculateMeatPerGuest(totalAttendees);

                Color beverageColor = Colors.black;
                String beverageStatus = '';
                if (committedBeverageLiters >= neededBeverageLiters * 0.9) {
                  beverageColor = Colors.green;
                  beverageStatus = 'Suficiente!';
                } else if (committedBeverageLiters >= neededBeverageLiters * 0.5) {
                  beverageColor = Colors.orange;
                  beverageStatus = 'Atenção, pode faltar.';
                } else {
                  beverageColor = Colors.red;
                  beverageStatus = 'Vai faltar MUITO!';
                }

                Color meatColor = Colors.black;
                String meatStatus = '';
                if (committedMeatKg >= neededMeatKg * 0.9) {
                  meatColor = Colors.green;
                  meatStatus = 'Suficiente!';
                } else if (committedMeatKg >= neededMeatKg * 0.5) {
                  meatColor = Colors.orange;
                  meatStatus = 'Atenção, pode faltar.';
                } else {
                  meatColor = Colors.red;
                  meatStatus = 'Vai faltar MUITO!';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Resumo e Análise de Itens', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Total de Bebidas Trazidas: ${committedBeverageLiters.toStringAsFixed(1)} Litros'),
                    Text('Estimativa Necessária: ${neededBeverageLiters.toStringAsFixed(1)} Litros'),
                    Text(
                      'Status Bebidas: $beverageStatus',
                      style: TextStyle(color: beverageColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Total de Carne Trazida: ${committedMeatKg.toStringAsFixed(1)} KG'),
                    Text('Estimativa Necessária: ${neededMeatKg.toStringAsFixed(1)} KG'),
                    Text(
                      'Status Carne: $meatStatus',
                      style: TextStyle(color: meatColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }

  String _getContributionOptionDescription(ItemContributionOption option) {
    switch (option) {
      case ItemContributionOption.predefinedList:
        return 'O anfitrião faz uma lista do que precisa.';
      case ItemContributionOption.none:
        return 'Os convidados NÃO precisam levar nada.';
      case ItemContributionOption.guestChooses:
        return 'Os convidados podem ESCOLHER livremente o que levar.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ItemContributionOption currentOption = widget.event.contributionOption;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
              'Data: ${widget.event.date.day}/${widget.event.date.month}/${widget.event.date.year} às ${widget.event.date.hour.toString().padLeft(2, '0')}:${widget.event.date.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            const Text(
              'Opção de Contribuição de Itens:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getContributionOptionDescription(currentOption),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            if (currentOption == ItemContributionOption.predefinedList && widget.event.predefinedItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Itens Sugeridos pelo Anfitrião:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.event.predefinedItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.event.predefinedItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('• $item', style: const TextStyle(fontSize: 16)),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),

            ElevatedButton.icon(
              onPressed: _generateAndCopyInviteLink,
              icon: const Icon(Icons.share),
              label: const Text('Gerar e Copiar Link de Convite'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildItemSummaryAndAnalysis(),

            const Text(
              'Adicionar Novo Convidado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newGuestNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Convidado',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newGuestEmailController,
              decoration: const InputDecoration(
                labelText: 'Email do Convidado',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addNewGuest,
              child: const Text('Adicionar Convidado'),
            ),
            const SizedBox(height: 24),

            const Text(
              'Lista de Convidados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildGuestList(),
            const SizedBox(height: 24),

            const Text(
              'Registrar Item Trazido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newItemNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Item (Ex: Bolo)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newItemQuantityController,
              decoration: const InputDecoration(
                labelText: 'Quantidade (opcional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addNewItemToCommittedList,
              child: const Text('Registrar Item'),
            ),
            const SizedBox(height: 24),

            const Text(
              'Itens que os Convidados Vão Trazer:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCommittedItemList(),
          ],
        ),
      ),
    );
  }
}