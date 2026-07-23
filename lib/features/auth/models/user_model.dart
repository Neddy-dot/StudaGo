enum UserRole {
  admin,
  teacher,
  guard,
  driver,
  parent,
}

class UserModel {
  final String id;
  final String name;
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
  });
}
