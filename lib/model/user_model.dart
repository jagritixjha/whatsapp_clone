class UserModel {
  String? uid, displayName, email, phoneNumber, photoUrl;

  List<UserModel> friends;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    this.friends = const [],
  });

  Future<void> load() async {
    // if(uid == FireStoreServices.instance.currentUser!.uid){
    //   friends = await FireStoreServices.instance.getFriends();
    // }
  }

  factory UserModel.fromJson({required Map<String, dynamic> user}) => UserModel(
        uid: user['uid'],
        displayName: user['displayName'],
        email: user['email'],
        phoneNumber: user['phoneNumber'],
        photoUrl: user['photoUrl'],
      );

  Map<String, dynamic> get toMap => {
        'uid': uid ?? 'Null',
        'displayName': displayName ?? 'Null',
        'email': email ?? 'Null',
        'phoneNumber': phoneNumber ?? 'Null',
        'photoUrl': photoUrl ??
            'https://i.pinimg.com/1200x/3e/f1/ec/3ef1ec48b03076009518fdc3a0ab8e02.jpg',
      };
}
