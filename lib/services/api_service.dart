import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/sub_category.dart';
import '../utils/constants.dart';

class ApiService {
  static const String _baseUrl = 'https://coinoneglobal.in/crm/';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(Constants.categoryUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Subcategory>> fetchSubcategories(int categoryId) async {
    final response = await http.get(Uri.parse('${Constants.subcategoryUrl}$categoryId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Subcategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }
}
