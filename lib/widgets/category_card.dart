import 'package:flutter/material.dart';
import '../models/category.dart';
import '../utils/constants.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    String imageUrl = '${Constants.baseUrl}${category.imgUrlPath}';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/subcategory',
          arguments: category.id,
        );
      },
      child: Card(
        child: Column(
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(category.name, style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
