class ProductCategoryOrBrandModel {
  final String id;

  final String name;

  const ProductCategoryOrBrandModel({required this.id, required this.name});

  factory ProductCategoryOrBrandModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryOrBrandModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
