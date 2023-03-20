import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uId, email, name, group;
  int status;
  DateTime? doc;

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.group,
    required this.status,
    required this.doc,
  });

  factory UserModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data()! as Map<String, dynamic>;
    return UserModel(
      uId: doc.id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      group: map['group'] ?? '',
      status: map['status'] ?? 0,
      doc: DateTime.now(),
    );
  }
}
