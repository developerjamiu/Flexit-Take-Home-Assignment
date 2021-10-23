class UserDetail {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String picture;
  final String gender;
  final String email;
  final String dateOfBirth;
  final String phone;
  final Location location;
  final String registerDate;
  final String updatedDate;

  UserDetail({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.picture,
    required this.gender,
    required this.email,
    required this.dateOfBirth,
    required this.phone,
    required this.location,
    required this.registerDate,
    required this.updatedDate,
  });

  factory UserDetail.fromMap(Map<String, dynamic> map) => UserDetail(
        id: map['id'],
        title: map['title'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        picture: map['picture'],
        gender: map['gender'],
        email: map['email'],
        dateOfBirth: map['dateOfBirth'],
        phone: map['phone'],
        location: Location.fromMap(map['location']),
        registerDate: map['registerDate'],
        updatedDate: map['updatedDate'],
      );

  @override
  String toString() {
    return 'UserDetail(id: $id, title: $title, firstName: $firstName, lastName: $lastName, picture: $picture, gender: $gender, email: $email, dateOfBirth: $dateOfBirth, phone: $phone, location: $location, registerDate: $registerDate, updatedDate: $updatedDate)';
  }
}

class Location {
  final String street;
  final String city;
  final String state;
  final String country;
  final String timezone;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.timezone,
  });

  String get streetAddress => '$street, $city, $state, $country.';

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      timezone: map['timezone'],
    );
  }

  @override
  String toString() {
    return 'Location(street: $street, city: $city, state: $state, country: $country, timezone: $timezone)';
  }
}
