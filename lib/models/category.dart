class Category {
  final int id;
  final String name;
  final String imgUrlPath;

  Category({
    required this.id,
    required this.name,
    required this.imgUrlPath,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['Id'].toString()) ?? 0,  // Adjusting the id parsing
      name: json['Name'] ?? '',
      imgUrlPath: json['ImgUrlPath'] ?? '',
    );
  }
}
