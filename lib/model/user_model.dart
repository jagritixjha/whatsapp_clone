class UserModel{
  String?
  uid,displayName,email,phoneNumber,photoUrl;

  List<UserModel> friends=[];

  UserModel(this.uid,this.displayName,this.email,this.phoneNumber,this.photoUrl,this.friends);

  Future<void> load()async{
    // if(uid == FireStoreServices.instance.currentUser!.uid){
    //   friends = await FireStoreServices.instance.getFriends();
    // }
  }


  Map<String,dynamic> get toMap=> {
    'uid':uid??'Null',
    'displayName':displayName??'Null',
    'email':email??'Null',
    'phoneNumber':phoneNumber??'Null',
    'photoUrl':photoUrl??'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s',
  };
}