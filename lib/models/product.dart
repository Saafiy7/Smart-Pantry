class Product {
  final String name;
  final String category;
  final String brand;
  final double quantity;
  final String unit;
  final String storageLocation;
  final DateTime expirationDate;

  const Product({
    required this.name,
    required this.category,
    required this.brand,
    required this.quantity,
    required this.unit,
    required this.storageLocation,
    required this.expirationDate,
  });
}