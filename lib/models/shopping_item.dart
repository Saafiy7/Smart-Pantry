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

  ShoppingItem.fromName(String name)
    : id = DateTime.now().microsecondsSinceEpoch.toString(),
      name = name,
      quantity = 1,
      isBought = false;

  @override
  String toString() {
    return 'ShoppingItem($name, x$quantity, bought: $isBought)';
  }
}
