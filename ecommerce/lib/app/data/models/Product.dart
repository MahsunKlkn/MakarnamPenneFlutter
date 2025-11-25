// 'data/models/product_model.dart'

class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final double? discountRate; 
  final int stockQuantity;
  final String? sku;
  final bool isActive;
  final String? imageUrl;
  final int categoryId;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.discountRate,
    required this.stockQuantity,
    this.sku,
    required this.isActive,
    this.imageUrl,
    required this.categoryId,
    required this.dateCreated,
    required this.dateUpdated,
  });


  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateUpdated: DateTime.parse(json['dateUpdated'] as String),
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(), // Güvenli parse
      discountRate: (json['discountRate'] as num?)?.toDouble(), // Nullable parse
      stockQuantity: json['stockQuantity'] as int,
      sku: json['sku'] as String?,
      isActive: json['isActive'] as bool,
      imageUrl: json['imageUrl'] as String?,
      categoryId: json['categoryId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Product
      'name': name,
      'description': description,
      'price': price,
      'discountRate': discountRate,
      'stockQuantity': stockQuantity,
      'sku': sku,
      'isActive': isActive,
      'imageUrl': imageUrl ?? 'https://via.placeholder.com/150?text=Product',
      'categoryId': categoryId,
    };
  }
}