import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/category_page.dart';
import 'views/subcategory_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            return FutureBuilder<bool>(
              future: authService.getKeepMeLoggedInStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.data ?? false) {
                    return CategoryPage();
                  } else {
                    return LoginPage();
                  }
                }
              },
            );
          },
        ),
        routes: {
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          '/category': (_) => CategoryPage(),
          '/subcategory': (context) => SubcategoryPage(categoryId: null),
        },
      ),
    );
  }
}
