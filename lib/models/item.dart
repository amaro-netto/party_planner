// lib/models/item.dart

// Um modelo para representar um Item que pode ser levado a um evento.
class Item {
  final String id;
  final String name;
  final int? quantityNeeded;

  // Construtor.
  Item({
    required this.id,
    required this.name,
    this.quantityNeeded,
  });

  // Método para converter Item para um mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantityNeeded': quantityNeeded,
    };
  }

  // Método para criar um objeto Item a partir de um mapa.
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as String,
      name: map['name'] as String,
      quantityNeeded: map['quantityNeeded'] as int?,
    );
  }
}