import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/strings/urls.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client _client;

  AuthRemoteDatasourceImpl({required client}) : _client = client;
  @override
  Future<UserModel> login(String email, String password) async {
    final body = jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    try {
      final response = await _client.post(
        Uri.parse(URLs.LoginUrl),
        body: body,
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw ServerException(message: responseData['error']['message']);
      }
      final user = UserModel.fromJson(responseData);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    final body = jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    try {
      final response = await _client.post(
        Uri.parse(URLs.SignUpUrl),
        body: body,
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw ServerException(message: responseData['error']['message']);
      }
      final user = UserModel.fromJson(responseData);
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
