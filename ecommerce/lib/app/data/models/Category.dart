// lib/app/data/models/Category.dart

class CategoryModel {
  // BaseEntity'den gelen alanlar
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.dateCreated,
    required this.dateUpdated,
  });

  /// JSON (Map) verisinden bir CategoryModel nesnesi oluşturan factory constructor.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateUpdated: DateTime.parse(json['dateUpdated'] as String),
    );
  }

  /// CategoryModel nesnesini JSON (Map)'e dönüştürür (POST ve PUT için).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }
}