class User {
  int userId;
  String email;
  String userName;
  String firstName;
  String lastName;
  String role;

  User(
    this.userId,
    this.email,
    this.userName,
    this.firstName,
    this.lastName,
    this.role,
  );

  String getFullname() => '${this.firstName} ${this.lastName}';

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'username': userName,
        'firstname': firstName,
        'lastname': lastName,
        'role': role,
      };

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        email = json['email'],
        userName = json['username'],
        firstName = json['firstname'],
        lastName = json['lastname'],
        role = json['role'];
}
