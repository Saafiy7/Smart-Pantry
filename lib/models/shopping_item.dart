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

  @override
  String toString() {
    return 'ShoppingItem($name, x$quantity, bought: $isBought)';
  }
}
