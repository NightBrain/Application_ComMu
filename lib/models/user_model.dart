class UserModel {
  final String uid;
  final String name;
  final String surname;
  final String email;
  final String gender;
  final String? imageURL;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.gender,
    this.imageURL,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'email': email,
      'gender': gender,
      'imageURL': imageURL,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create UserModel from Map (from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      imageURL: map['imageURL'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? uid,
    String? name,
    String? surname,
    String? email,
    String? gender,
    String? imageURL,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      imageURL: imageURL ?? this.imageURL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get full name
  String get fullName => '$name $surname';

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, surname: $surname, email: $email, gender: $gender, imageURL: $imageURL, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.surname == surname &&
        other.email == email &&
        other.gender == gender &&
        other.imageURL == imageURL &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        imageURL.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
} 