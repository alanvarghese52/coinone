import 'package:flutter/material.dart';
import '../models/sub_category.dart';
import '../utils/constants.dart';

class SubcategoryCard extends StatelessWidget {
  final Subcategory subcategory;

  SubcategoryCard({required this.subcategory});

  @override
  Widget build(BuildContext context) {
    String imageUrl = '${Constants.baseUrl}${subcategory.imgUrlPath}';

    return Card(
      child: Column(
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(subcategory.name, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
