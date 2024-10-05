class BoxSize {
  final String name;
  final String id;
  final double length;
  final double width;
  final double height;
  final double weight;

  BoxSize({
    required this.id,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.name,
  });

  // Factory constructor to create a BoxSize instance from a JSON map
  factory BoxSize.fromJson(Map<String, dynamic> json) {
    return BoxSize(
      id: json['id'],
      name: json['box_name'],
      length: json['length'].toDouble(),
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
    );
  }

  // Method to convert BoxSize instance to a JSON map
  Map<String, dynamic> toJson() {
    return {

      'id': id,
      'box_name': name,
      'length': length,
      'width': width,
      'height': height,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return 'BoxSize(id: $id,box_name:$name, length: $length, width: $width, height: $height, weight: $weight)';
  }
}
