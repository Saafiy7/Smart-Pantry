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
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'brand': brand,
      'quantity': quantity,
      'unit': unit,
      'storageLocation': storageLocation,
      'expirationDate': expirationDate.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      storageLocation: json['storageLocation'] as String,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      imageUrl: json['imageUrl'] as String?,
    );
  }
    int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiration = DateTime(
      expirationDate.year,
      expirationDate.month,
      expirationDate.day,
    );
    return expiration.difference(today).inDays;
  }

  bool get isExpired => daysLeft < 0;

  bool get isExpiringSoon => daysLeft <= 3;

  bool get isUseSoon => daysLeft <= 7;

  String get statusLabel {
    if (isExpired) return 'Expired';
    if (isExpiringSoon) return 'Expiring soon';
    if (isUseSoon) return 'Use soon';
    return 'Fresh';
  }

  String get expiryText {
    if (daysLeft < 0) return 'Expired';
    if (daysLeft == 0) return 'Expires today';
    if (daysLeft == 1) return 'Expires tomorrow';
    return 'Expires in $daysLeft days';
  }
}