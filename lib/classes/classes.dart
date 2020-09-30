import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  String subjectName;
  String assignmentDescription;
  String assignmentId;
  String assignmentDueDate;
  String assignmentDueTime;
  String assignmentAssignedDate;
  String assignmentLink;
  bool active;
  String uploadsPath;
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
      this.uploadsPath});

  Assignment.fromMap(Map<String, dynamic> map, {this.reference}) {
    subjectName = map['subjectName'].toString();
    assignmentDescription = map['assignmentDescription'].toString();
    assignmentId = map['assignmentId'].toString();
    assignmentDueDate = map['assignmentDueDate'].toString();
    assignmentAssignedDate = map['assignmentAssignedDate'];
    assignmentLink = map['assignmentLink'].toString();
    assignmentDueTime = map['assignmentDueTime'].toString();
    active = map['active'];
    uploadsPath = map['uploads'];
  }

  Assignment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class Submission {
  String submitterUID;
  String submitterName;
  String submitterDescription;
  String submissionId;
  String submitterDateAndTime;
  String submitterFileLink;

  final DocumentReference reference;

  Submission(this.reference,
      {this.submitterUID,
      this.submitterName,
      this.submitterDescription,
      this.submitterDateAndTime,
      this.submitterFileLink,
      this.submissionId});

  Submission.fromMap(Map<String, dynamic> map, {this.reference}) {
    submitterUID = map['submitterUID'].toString();
    submitterName = map['submitterName'].toString();
    submitterDescription = map['submitterDescription'].toString();
    submitterDateAndTime = map['submitterDateAndTime'].toString();
    submitterFileLink = map['submitterFileLink'].toString();
    submissionId = map['submissionId'].toString();
  }

  Submission.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
