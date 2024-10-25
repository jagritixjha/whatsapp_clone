class ChatModal {
  String? message, type, status;
  DateTime? time;

  ChatModal(this.time, this.message, this.type, this.status);

  factory ChatModal.fromMap(Map data) => ChatModal(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(data['time'])),
        data['message'],
        data['type'],
        data['status'],
      );

  Map<String, dynamic> get toMap => {
        'time': time?.microsecondsSinceEpoch.toString() ?? '000',
        'message': message ?? 'nan',
        'type': type,
        'status': status,
      };
}
