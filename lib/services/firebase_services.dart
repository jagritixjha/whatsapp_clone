import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:whatsapp_clone/model/chat_model.dart';
import 'package:whatsapp_clone/model/todo_model.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/services/auth_services.dart';

class FirestoreServices {
  FirestoreServices._();
  static final FirestoreServices instance = FirestoreServices._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String todoCollection = 'todo';
  String userCollection = 'allUsers';
  String friendsCollection = 'friends';
  String chatsCollection = 'chats';

  UserModel? currentUser;

  // add new user
  Future<void> addUser({required User user}) async {
    Map<String, dynamic> newUserData = {
      'uid': user.uid,
      'displayName': user.displayName ?? 'Your name',
      'email': user.email ?? 'Your email',
      'phoneNumber': user.phoneNumber ?? 'Your phone number',
      'photoUrl': user.photoURL ??
          'https://i.pinimg.com/1200x/3e/f1/ec/3ef1ec48b03076009518fdc3a0ab8e02.jpg',
    };
    await fireStore.collection(userCollection).doc(user.uid).set(newUserData);
  }

  // get user data
  Future<void> getUser() async {
    DocumentSnapshot snapshot = await fireStore
        .collection(userCollection)
        .doc(AuthServices.instance.auth.currentUser!.uid)
        .get();
    currentUser =
        UserModel.fromJson(user: snapshot.data() as Map<String, dynamic>);
  }

  // add data
  Future<void> addTodo({required TodoModel todoModel}) async {
    // Auto ID
    // await fireStore.collection(collectionPath).add(todoModel.toMap);

    // custom ID
    await fireStore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(todoCollection)
        .doc(todoModel.id)
        .set(todoModel.toMap);
  }

  Future<List<TodoModel>> getData() async {
    List<TodoModel> allTodo = [];

    // get snapshot
    QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(todoCollection)
        .get();
    /*  QuerySnapshot:
    Contains metadata and a list of QueryDocumentSnapshot objects in docs.  */

    // get Docs
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    /*  QuerySnapshot.docs:
    A list of QueryDocumentSnapshot objects, each one representing a document from the query results.  */

    // parse data
    allTodo = docs
        .map(
          (e) => TodoModel.fromMap(e.data() as Map),
        )
        .toList();
    /*  Accessing Document Data:
    To get the data of each document, you call .data() on each QueryDocumentSnapshot, which returns a Map<String, dynamic>.  */

    return allTodo;
  }

  // stream data
  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return fireStore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(todoCollection)
        .snapshots();
  }

  // update data
  Future<void> updateStatus({required TodoModel todoModel}) async {
    await fireStore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(todoCollection)
        .doc(todoModel.id)
        .update(todoModel.toMap);
  }

  // get all users
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return fireStore.collection(userCollection).snapshots();
  }

  // add friend
  Future<void> addFriend({required UserModel userModel}) async {
    // adding any other user(userModal) to the current user's friends docs.
    await fireStore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(friendsCollection)
        .doc(userModel.uid)
        .set(userModel.toMap)
        .then((value) => Logger().i('Added to friend doc'))
        .onError(
          (error, stackTrace) => Logger().e('Error : ${error.toString()}'),
        );

    // adding current user(currentUser) to the other user's friends docs.
    await fireStore
        .collection(userCollection)
        .doc(userModel.uid)
        .collection(friendsCollection)
        .doc(currentUser!.uid)
        .set(currentUser!.toMap);
  }

  // get friends
  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsStream() {
    return fireStore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(friendsCollection)
        .snapshots();
  }

  // set chat
  Future<void> setChat(
      {required ChatModal chat, required UserModel userModal}) async {
    await fireStore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(friendsCollection)
        .doc(userModal.uid)
        .collection(chatsCollection)
        .doc(chat.time?.microsecondsSinceEpoch.toString())
        .set(chat.toMap);

    /* another way
      await fireStore
        .collection('chats')
        .doc(
            '${currentUser!.uid}_${userModal.uid}') // chatId for the conversation
        .collection('messages')
        .doc(DateTime.now()
            .microsecondsSinceEpoch
            .toString()) // Unique message ID, based on timestamp
        .set(chat.toMap);
    */
  }

  // get chat stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream(
      {required UserModel userModal}) {
    return fireStore
        .collection(userCollection)
        .doc(currentUser!.uid)
        .collection(friendsCollection)
        .doc(userModal.uid)
        .collection(chatsCollection)
        .snapshots();

    /* another way
      return fireStore
        .collection('chats')
        .doc(
            '${currentUser!.uid}_${userModal.uid}') // chatId is a combination of current user's ID and the other user's ID
        .collection('messages')
        .orderBy(
            'timestamp') // Orders messages by timestamp to display in the right order
        .snapshots();
    */
  }
}
