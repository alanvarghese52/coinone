// views/subcategory_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sub_category.dart'; // Ensure correct import path for Subcategory model

class SubcategoryPage extends StatefulWidget {
  final int categoryId;

  const SubcategoryPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  late Future<List<Subcategory>> _subcategoriesFuture;

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture = fetchSubcategories(widget.categoryId);
  }

  Future<List<Subcategory>> fetchSubcategories(int categoryId) async {
    final url = 'https://coinoneglobal.in/teresa_trial/webtemplate.asmx/FnGetTemplateSubCategoryList?PrmCmpId=1&PrmBrId=2&PrmCategoryId=$categoryId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> decodedResponse = json.decode(response.body)['d'];
      print('API response: $decodedResponse'); // Log the raw response

      return decodedResponse.map((json) => Subcategory.fromJson(json)).toList();
    } else {
      print('Failed to load subcategories: ${response.statusCode}');
      throw Exception('Failed to load subcategories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategories for Category ${widget.categoryId}'),
      ),
      body: FutureBuilder<List<Subcategory>>(
        future: _subcategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}'); // Log the error
            return const Center(child: Text('Failed to load subcategories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subcategories available'));
          } else {
            final subcategories = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                final imageUrl = 'https://coinoneglobal.in/crm/${subcategory.imgUrlPath}';

                return GestureDetector(
                  onTap: () {
                    // Handle onTap action for subcategory item if needed
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.error)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            subcategory.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
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
