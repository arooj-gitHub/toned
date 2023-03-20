import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/program.dart';
import '/services/datetime_converter.dart';

class Group {
  String id, title;
  int status, totalUsers;
  DateTime? doc;
  List<Program>? programsList;
  bool isPublic;

  Group({
    required this.id,
    required this.title,
    required this.status,
    required this.doc,
    required this.totalUsers,
    this.programsList,
    required this.isPublic,
  });

  factory Group.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Group(
      id: doc.id,
      title: '${map['title'] ?? ''}'.toString(),
      status: map['status'] ?? 0,
      totalUsers: map['total_users'] ?? 0,
      isPublic: map['isPublic'] ?? false,
      doc: DateTimeConverter().convert(map['doc']),
    );
  }
}
