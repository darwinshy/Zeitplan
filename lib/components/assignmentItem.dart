import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget itemTileAssignement(DocumentSnapshot data) {
  final record = Assignment.fromSnapshot(data);
  return ListTile(
    title: Text(record.subjectName),
  );
}

class Assignment {
  String subjectName;
  String assignmentDescription;
  String assignmentId;
  String assignmentDueDate;
  String assignmentDueTime;
  String assignmentAssignedDate;
  String assignmentLink;
  bool active;
  List<List<String>> uploads;
  final DocumentReference reference;

  Assignment(this.reference,
      {this.subjectName,
      this.assignmentDescription,
      this.assignmentId,
      this.assignmentDueDate,
      this.assignmentDueTime,
      this.assignmentAssignedDate,
      this.assignmentLink,
      this.active,
      this.uploads});

  Assignment.fromMap(Map<String, dynamic> map, {this.reference}) {
    subjectName = map['subjectName'];
    assignmentDescription = map['assignmentDescription'];
    assignmentId = map['assignmentId'];
    assignmentDueDate = map['assignmentDueDate'];
    assignmentAssignedDate = map['assignmentAssignedDate'];
    assignmentLink = map['assignmentLink'];
    assignmentDueTime = map['assignmentDueTime'];
    active = map['active'];
    if (map['uploads'] != null) {
      uploads = new List<List<String>>();
      map['uploads'].forEach((v) {
        uploads.add(new List.from(v).toList());
      });
    }
  }

  Assignment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
