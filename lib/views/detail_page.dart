import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class DetailsPage extends StatefulWidget {
  final int categoryId;

  const DetailsPage({super.key, required this.categoryId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Future<List<SubCategory>> fetchSubCategories() async {
    final response = await http.get('https://coinoneglobal.in/teresa_trial/webtemplate.asmx/FnGetTemplateSubCategoryList?PrmCmpId=1&PrmBrId=2&PrmCategoryId=${widget.categoryId}' as Uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SubCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: FutureBuilder<List<SubCategory>>(
        future: fetchSubCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final subCategories = snapshot.data;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: subCategories?.length,
              itemBuilder: (context, index) {
                final subCategory = subCategories?[index];
                final imageUrl = 'https://coinoneglobal.in/crm/${subCategory?.imgUrlPath}';
                return Card(
                  child: Column(
                    children: [
                      CachedNetworkImage(imageUrl: imageUrl),
                      Text(subCategory!.name),
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
