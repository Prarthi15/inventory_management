class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  // Factory constructor to create a Category instance from a JSON map
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  // Method to convert Category instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name)';
  }
}
