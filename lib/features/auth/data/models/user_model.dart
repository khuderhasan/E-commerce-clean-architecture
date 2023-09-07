import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.authToken,
    required super.userId,
    required super.expiryDate,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      authToken: json['idToken'],
      userId: json['localId'],
      expiryDate: DateTime.now().add(
        Duration(seconds: int.parse(json['expiresIn'])),
      ),
    );
  }
}
