class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  bool isBought;

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.isBought = false,
  });

  ShoppingItem.fromName(this.name)
    : id = DateTime.now().microsecondsSinceEpoch.toString(),
      quantity = 1,
      isBought = false;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as int?) ?? 1,
      isBought: (json['isBought'] as bool?) ?? false,
    );
  }
   Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'quantity': quantity, 'isBought': isBought};
  }

  @override
  String toString() {
    return 'ShoppingItem($name, x$quantity, bought: $isBought)';
  }
}
