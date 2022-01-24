import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String subjectCode;
  final String subjectName;
  final String startTime;
  final String endTime;
  final String link;
  final String about;
  final String meetingStatus;
  final DocumentReference reference;

  Schedule.fromMap(Map<String, dynamic> map, {this.reference})
      : subjectCode = map['sCode'],
        subjectName = map['sName'],
        startTime = map['startTime'],
        endTime = map['endTime'],
        about = map['about'],
        link = map['link'],
        meetingStatus = map["mStatus"];

  Schedule.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class Classmate {
  final String email;
  final String fullname;
  final String cr;
  final String batchBranch;
  final String phoneNumber;
  final String scholarId;
  final String section;
  final String photoURL;
  final String verified;
  final DocumentReference reference;

  Classmate.fromMap(Map<String, dynamic> map, {this.reference})
      : cr = map['CR'].toString(),
        photoURL = map['url'].toString(),
        batchBranch = map['branch'],
        phoneNumber = map['phone'],
        scholarId = map['scholarId'],
        fullname = map["name"],
        section = map['section'],
        email = map["email"],
        verified = map['verified'].toString();

  Classmate.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
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
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class Submission {
  String submitterUID;
  String submitterName;
  String submissionTopic;
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
    submissionTopic = map["submissionTopic"].toString();
    submitterDescription = map['submitterDescription'].toString();
    submitterDateAndTime = map['submitterDateAndTime'].toString();
    submitterFileLink = map['submitterFileLink'].toString();
    submissionId = map['submissionId'].toString();
  }

  Submission.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class QuestionPaper {
  String questionPaperSubjectName;
  String questionPaperSubjectCode;
  String questionPaperMidEnd;
  int questionPaperSemester;
  String questionPaperYear;
  String questionPaperSubmitterName;
  String questionPaperSubmitterUID;
  String questionPaperUploadDateAndTime;
  String questionPaperLink;

  final DocumentReference reference;

  QuestionPaper(
    this.reference, {
    this.questionPaperSubjectName,
    this.questionPaperSubjectCode,
    this.questionPaperMidEnd,
    this.questionPaperSemester,
    this.questionPaperYear,
    this.questionPaperSubmitterName,
    this.questionPaperSubmitterUID,
    this.questionPaperUploadDateAndTime,
    this.questionPaperLink,
  });

  QuestionPaper.fromMap(Map<String, dynamic> map, {this.reference}) {
    questionPaperSubjectName = map['questionPaperSubjectName'].toString();
    questionPaperSubjectCode = map['questionPaperSubjectCode'].toString();
    questionPaperMidEnd = map['questionPaperMidEnd'].toString();
    questionPaperSemester = map['questionPaperSemester'];
    questionPaperYear = map['questionPaperYear'].toString();
    questionPaperSubmitterName = map['questionPaperSubmitterName'].toString();
    questionPaperSubmitterUID = map['questionPaperSubmitterUID'].toString();
    questionPaperUploadDateAndTime =
        map['questionPaperUploadDateAndTime'].toString();
    questionPaperLink = map['questionPaperLink'].toString();
  }

  QuestionPaper.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
