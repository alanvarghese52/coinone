import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SubCategoryPage extends StatefulWidget {
  final int categoryId;

  const SubCategoryPage({super.key, required this.categoryId});

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  late Future<List<SubCategory>> _subCategories;

  @override
  void initState() {
    super.initState();
    _subCategories = fetchSubCategories(widget.categoryId);
  }

  Future<List<SubCategory>> fetchSubCategories(int categoryId) async {
    final response = await http.get(
      Uri.parse('https://coinoneglobal.in/teresa_trial/webtemplate.asmx/FnGetTemplateSubCategoryList?PrmCmpId=1&PrmBrId=2&PrmCategoryId=$categoryId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['d'];
      return data.map((json) => SubCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subcategories'),
      ),
      body: FutureBuilder<List<SubCategory>>(
        future: _subCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subcategories found'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final subCategory = snapshot.data![index];
                final imageUrl = 'https://coinoneglobal.in/crm/${subCategory.imgUrlPath}';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(imageUrl, height: 100, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 8),
                      Text(subCategory.name, textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SubCategory {
  final int id;
  final String name;
  final String imgUrlPath;

  SubCategory({required this.id, required this.name, required this.imgUrlPath});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['Id'],
      name: json['Name'],
      imgUrlPath: json['ImgUrlPath'],
    );
  }
}
