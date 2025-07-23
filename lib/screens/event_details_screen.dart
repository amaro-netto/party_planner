// lib/screens/event_details_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/models/event.dart'; // Importa o modelo de Evento
import 'package:party_planner/models/guest.dart'; // Importa o modelo de Convidado
import 'package:party_planner/models/item.dart';   // Importa o modelo de Item
import 'package:party_planner/services/event_service.dart'; // Importa o serviço de Eventos

class EventDetailsScreen extends StatefulWidget {
  final Event event; // O evento que será exibido nesta tela.

  const EventDetailsScreen({required this.event, super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventService _eventService = EventService(); // Instância do serviço de eventos
  late Future<List<Guest>> _guestsFuture; // Future para a lista de convidados
  late Future<List<Item>> _itemsFuture;   // Future para a lista de itens que os convidados se comprometeram a levar

  // Um TextEditingController para adicionar novos convidados rapidamente.
  final TextEditingController _newGuestNameController = TextEditingController();
  final TextEditingController _newGuestEmailController = TextEditingController();

  // Um TextEditingController para adicionar novos itens a levar (para o anfitrião, em "predefinedList" ou para acompanhamento).
  final TextEditingController _newItemNameController = TextEditingController();
  final TextEditingController _newItemQuantityController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Carrega os convidados e itens quando a tela é iniciada.
    _loadEventData();
  }

  // Método para carregar (ou recarregar) os dados do evento (convidados e itens).
  void _loadEventData() {
    setState(() {
      _guestsFuture = _eventService.getGuestsForEvent(widget.event.id);
      _itemsFuture = _eventService.getItemsForEvent(widget.event.id);
    });
  }

  // Método para adicionar um novo convidado (simulado).
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
      _loadEventData(); // Recarrega a lista de convidados
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Convidado adicionado com sucesso!')),
      );
      // Opcional: Fechar o teclado.
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao adicionar convidado.')),
      );
    }
  }

  // Método para adicionar um novo item (simulado).
  // Este item é para o anfitrião adicionar à lista de "itens que os convidados se comprometeram a trazer"
  // ou para um controle interno. Não é para a lista pré-definida do evento.
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
      _loadEventData(); // Recarrega a lista de itens
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

  // Widget para exibir a lista de convidados
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
          return ListView.builder(
            shrinkWrap: true, // Importante para ListView aninhado dentro de Column
            physics: const NeverScrollableScrollPhysics(), // Desabilita o scroll da lista interna
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
                      Text('Vai? ${guest.isAttending ? 'Sim' : 'Não'}'),
                      if (guest.plusOneCount > 0)
                        Text('Acompanhantes: ${guest.plusOneCount}'),
                      if (guest.itemBringing != null && guest.itemBringing!.isNotEmpty)
                        Text('Trazendo: ${guest.itemBringing}'),
                    ],
                  ),
                  trailing: Checkbox(
                    value: guest.isAttending,
                    onChanged: (bool? newValue) async {
                      // Simula a atualização do status de presença
                      final updatedGuest = Guest(
                        id: guest.id,
                        name: guest.name,
                        email: guest.email,
                        isAttending: newValue!,
                        plusOneCount: guest.plusOneCount,
                        itemBringing: guest.itemBringing,
                      );
                      await _eventService.updateGuest(widget.event.id, updatedGuest);
                      _loadEventData(); // Recarrega a lista após a atualização
                    },
                  ),
                  onTap: () {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Editar detalhes de ${guest.name}')),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  // Widget para exibir a lista de itens que os convidados se comprometeram a trazer
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
                      ? Text('Quantidade Trazida: ${item.quantityNeeded}') // Mudei para 'Trazida'
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Deletar item: ${item.name}')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Método para obter a descrição da opção de contribuição
  String _getContributionOptionDescription(ItemContributionOption option) {
    switch (option) {
      case ItemContributionOption.predefinedList:
        return 'O anfitrião faz uma lista do que precisa.';
      case ItemContributionOption.none:
        return 'Os convidados NÃO precisam levar nada.';
      case ItemContributionOption.guestChooses:
        return 'Os convidados podem ESCOLHER livremente o que levar.';
      default:
        return 'Opção desconhecida.';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenha a opção de contribuição do evento.
    final ItemContributionOption currentOption = widget.event.contributionOption;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title), // Título da AppBar é o nome do evento
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView( // Permite rolar toda a tela de detalhes
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Detalhes do Evento
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

            // NOVO: Seção da Opção de Contribuição de Itens
            const Text(
              'Opção de Contribuição de Itens:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getContributionOptionDescription(currentOption), // Mostra a descrição da opção
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // NOVO: Lista de Itens Pré-definidos (se a opção for 'predefinedList')
            if (currentOption == ItemContributionOption.predefinedList && widget.event.predefinedItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Itens Sugeridos pelo Anfitrião:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Exibe os itens pré-definidos do evento
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

            // Seção Adicionar Convidado (mantida para o anfitrião)
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

            // Seção Lista de Convidados
            const Text(
              'Lista de Convidados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildGuestList(), // Chama o widget que constrói a lista de convidados
            const SizedBox(height: 24),

            // Seção Adicionar Item (para o anfitrião, para controle interno de itens trazidos)
            const Text(
              'Registrar Item Trazido', // Mudei o título
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
              onPressed: _addNewItemToCommittedList, // Mudamos o nome do método
              child: const Text('Registrar Item'), // Mudei o texto do botão
            ),
            const SizedBox(height: 24),

            // Seção Lista de Itens que os convidados se comprometeram a trazer
            const Text(
              'Itens que os Convidados Vão Trazer:', // Mudei o título
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCommittedItemList(), // Chama o widget que constrói a lista de itens
          ],
        ),
      ),
    );
  }
}