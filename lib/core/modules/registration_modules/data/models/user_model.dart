class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phoneNumber;
  final String createdAt;

  const UserModel({
    required this.name,
    required this.phoneNumber,
    required this.uid,
    required this.createdAt,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
    };
  }
}
