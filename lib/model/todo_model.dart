class TodoModel {
  String id, title;
  bool status;
  int dTime;

  TodoModel(this.id, this.title, this.status, this.dTime);
  factory TodoModel.fromMap(Map data) => TodoModel(
        data['id'],
        data['title'],
        data['status'],
        data[' dTime'],
      );

  Map<String, dynamic> get toMap => {
        'id': id,
        'title': title,
        'status': status,
        'dTime': dTime,
      };
}
