import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  FirebaseServices._();
  static final FirebaseServices instance = FirebaseServices._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String collectionPath = 'Todo';
  String userCollection = 'allUsers';

  UserModel? currentUser;
}
