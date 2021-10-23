class UsersResponse {
  final List<User> users;

  UsersResponse({required this.users});

  factory UsersResponse.fromMap(Map<String, dynamic> map) {
    return UsersResponse(
      users: List<User>.from(map['data']?.map((user) => User.fromMap(user))),
    );
  }

  @override
  String toString() => 'UsersResponse(users: $users)';
}

class User {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String picture;

  User({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.picture,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        title: map['title'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        picture: map['picture'],
      );

  @override
  String toString() {
    return 'User(id: $id, title: $title, firstName: $firstName, lastName: $lastName, picture: $picture)';
  }
}
