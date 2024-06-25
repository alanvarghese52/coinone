import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool isLoggedIn = false;

  AuthService() {
    _auth.authStateChanges().listen((user) async {
      _user = user;
      isLoggedIn = user != null;
      notifyListeners();

      if (isLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', true);
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> register(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Add additional user info (like username) to Firestore or your preferred database if needed.
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
  }

  Future<bool> getKeepMeLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  Future<void> saveKeepMeLoggedInStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', status);
  }
}
