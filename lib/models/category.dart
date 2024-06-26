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
      id: json['Id'],
      name: json['Name'],
      imgUrlPath: json['ImgUrlPath'],
    );
  }
}
