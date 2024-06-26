import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password, String username) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.updateDisplayName(username);
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await saveKeepMeLoggedInStatus(false);
      _onAuthStateChanged(null);
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign-out: $e');
      }
    }
  }

  Future<void> saveKeepMeLoggedInStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', status);
  }

  Future<bool> getKeepMeLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }
}
