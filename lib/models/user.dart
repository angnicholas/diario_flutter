class UserModel {
  final String username;
  final String accessToken;
  final String refreshToken;
  final int id;

  UserModel({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    required this.id,
  });
}
