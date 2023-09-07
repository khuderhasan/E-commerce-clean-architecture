import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUser with ChangeNotifier {
  String? userId;
  String? authToken;
  DateTime? expiryDate;
  Timer? authTimer;

  void setCurrentUser(
      {required String userId,
      required String authToken,
      required DateTime expiryDate}) async {
    this.userId = userId;
    this.authToken = authToken;
    this.expiryDate = expiryDate;
    _autoLogOut();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'authToken': authToken,
        'userId': userId,
        'expiryDate': expiryDate.toIso8601String(),
      },
    );
    prefs.setString('userData', userData);
  }

  Future<void> logOut() async {
    authToken = null;
    userId = '';
    expiryDate = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogOut() {
    if (authTimer != null) {
      authTimer!.cancel();
    }
    final timeToExpire = expiryDate?.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpire!), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(sharedPref.getString('userData')!) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    authToken = userData['authToken'];
    userId = userData['userId'];
    this.expiryDate = expiryDate;

    notifyListeners();
    _autoLogOut();
    return true;
  }
}
