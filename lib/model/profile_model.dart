class ProfileModel {
  final String name;
  final String email;
  final String userId;
  final String? profileImage;

  ProfileModel(
      {required this.name,
      required this.email,
      required this.userId,
      this.profileImage});

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'],
      email: map['email'],
      userId: map['userId'],
      profileImage: map['profileImage'],
    );
  }
}
