// class TodoModel {
//   String? title;
//   bool? isCompleted;
//   String? time;
//   TodoModel({
//     this.isCompleted = false,
//     this.title,
//     this.time,
//   });
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? documentId;
  late String title;
  String? time;
  bool? iscompleted;
  // late Timestamp createdOn;
  // late bool isDone;

  TodoModel({
    required this.title,
    this.documentId,
    this.iscompleted,
    this.time,
    // required this.isDone,
//     required this.createdOn,
  });

  TodoModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    title = documentSnapshot["title"];
    time = documentSnapshot['time'];
    iscompleted = documentSnapshot['isCompleted'];
    // isDone = documentSnapshot["isDone"];
  }
}
