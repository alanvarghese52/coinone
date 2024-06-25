import 'package:flutter/material.dart';
import '../models/sub_category.dart';
import '../services/api_service.dart';
import '../widgets/subcategory_card.dart';

class SubcategoryPage extends StatelessWidget {
  final int? categoryId;

  SubcategoryPage({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    if (categoryId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Subcategories'),
        ),
        body: Center(
          child: Text('No category selected.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategories'),
      ),
      body: FutureBuilder<List<Subcategory>>(
        future: ApiService().fetchSubcategories(categoryId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load subcategories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No subcategories found'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return SubcategoryCard(subcategory: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
