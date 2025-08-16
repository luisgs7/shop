import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  static const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBjaatVrICKkvZUWxTCP57NJzMT1g9-IbI';
  
  Future<void> _authenticate(
    String email, String password, String urlFragment
  ) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyBjaatVrICKkvZUWxTCP57NJzMT1g9-IbI';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    print(jsonDecode(response.body));
  }


  Future<void> signup(String email, String password) async {
    await _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    await _authenticate(email, password, 'signInWithPassword');
  }
}