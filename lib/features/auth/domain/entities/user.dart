import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String authToken;
  final String userId;
  final DateTime expiryDate;

  const User({
    required this.authToken,
    required this.userId,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [authToken, userId, expiryDate];
}
