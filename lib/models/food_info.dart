class FoodInfo {
  final String code;
  final String name;
  final String brand;
  final String? imageUrl;

  const FoodInfo({
    required this.code,
    required this.name,
    required this.brand,
    this.imageUrl,
  });

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
      code: json['code'].toString(),
      name: (json['product_name'] ?? '') as String,
      brand: (json['brands'] ?? '') as String,
      imageUrl: json['image_url'] as String?,
    );
  }
}