class Product {
  final String id;
  final String name;
  final String category;
  final String brand;
  final double quantity;
  final String unit;
  final String storageLocation;
  final DateTime expirationDate;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.quantity,
    required this.unit,
    required this.storageLocation,
    required this.expirationDate,
    this.imageUrl,
  });

  Product copyWith({
    String? name,
    String? category,
    String? brand,
    double? quantity,
    String? unit,
    String? storageLocation,
    DateTime? expirationDate,
    String? imageUrl,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      storageLocation: storageLocation ?? this.storageLocation,
      expirationDate: expirationDate ?? this.expirationDate,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}