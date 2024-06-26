class Subcategory {
  final int id;
  final String name;
  final String imgUrlPath;

  Subcategory({
    required this.id,
    required this.name,
    required this.imgUrlPath
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['Id'],
      name: json['Name'],
      imgUrlPath: json['ImgUrlPath'],
    );
  }
}
