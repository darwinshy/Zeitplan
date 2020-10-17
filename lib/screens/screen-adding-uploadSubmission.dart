import '../components/animations.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../components/reusables.dart';
import 'package:intl/intl.dart';
import '../classes/classes.dart';
import 'package:flutter/material.dart';

import '../streamproviders.dart';

BuildContext uploadAssignmentScreenGlobalContext;

class UploadAssignmentScreen extends StatefulWidget {
  final Assignment record;
  UploadAssignmentScreen(this.record);

  @override
  _UploadAssignmentScreenState createState() => _UploadAssignmentScreenState();
}

class _UploadAssignmentScreenState extends State<UploadAssignmentScreen> {
  //
  // final int limit = 4000000;
  String submitterUID;
  String submitterName;
  String submitterDescription;
  String submissionId;
  String submitterDateAndTime;
  String submitterFileLink;
  String databaseToSave;
  // File file;
  //
  String fullName;
  String userUID;
  //
  DateFormat formatter = DateFormat('ddMMyyyy');

  //
  final assignmentSubmissionForm = new GlobalKey<FormState>();
  //
  String getDateTime() {
    var value = DateTime.now().toLocal().toString().substring(0, 19);
    return value;
  }

  //
  bool validateFields() {
    if (submitterDescription.length > 30 && submitterDescription.length == 0) {
      showSomeAlerts("Description too long.", context);
      return false;
    }
    if (isURL(submitterFileLink) != true) {
      showSomeAlerts("Invalid Link.", context);
      return false;
    }
    return true;
  }

  //
  Future<void> createUniqueSubmissionDetails() async {
    final sharedpreferencedata = Provider.of<SharedPreferencesProviders>(
        uploadAssignmentScreenGlobalContext,
        listen: false);

    submitterDateAndTime = getDateTime();
    var cacheData = sharedpreferencedata.getAllSharedPreferenceData();
    cacheData.then((cacheItem) => {
          submitterName = cacheItem[0],
          submitterUID = cacheItem[7],
          submissionId = submitterUID + ":" + submitterDateAndTime,
          databaseToSave = widget.record.uploadsPath + "/" + submissionId
        });
  }

  //
  void validateTheSubmissionForm() {
    final assignmentFormData = assignmentSubmissionForm.currentState;
    assignmentFormData.save();

    if (validateFields() != false && assignmentFormData.validate()) {
      createUniqueSubmissionDetails()
          .whenComplete(() => {writeToDatabase(widget.record.uploadsPath)});
    }
  }

  //
  void writeToDatabase(String dbPath) async {
    showProgressBar(uploadAssignmentScreenGlobalContext);
    final dbqueries = Provider.of<DatabaseQueries>(
        uploadAssignmentScreenGlobalContext,
        listen: false);

    Map<String, dynamic> data = {
      "submitterUID": submitterUID,
      "submitterName": submitterName,
      "submissionTopic": widget.record.subjectName,
      "submitterDescription": submitterDescription,
      "submissionId": submissionId,
      "submitterDateAndTime": submitterDateAndTime.toString(),
      "submitterFileLink": submitterFileLink,
    };
    var result = dbqueries.addDocumentWithUniqueID(dbPath, submissionId, data);
    result.then(
        (value) => {Navigator.of(context).pop(), Navigator.of(context).pop()});
  }
  // final sharedpreferencedata = Provider.of<SharedPreferencesProviders>(
  //     uploadAssignmentScreenGlobalContext,
  //     listen: false);
  //
  // void uploadFileFunction() async {
  //   FilePickerResult pickFile = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.custom,
  //     withData: true,
  //     allowedExtensions: ['jpg', 'pdf', 'doc'],
  //   );
  //   file = File(pickFile.paths[0]);

  //   int sizeinBytes = int.parse(file.lengthSync().toString());

  //   String size = filesize(file.lengthSync().toString());

  //   if (sizeinBytes <= limit) {
  //     print(size);
  //   }
  // }

  //
  @override
  Widget build(BuildContext context) {
    uploadAssignmentScreenGlobalContext = context;
    return Scaffold(
      body: buildForm(),
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black87,
      child: Form(
        key: assignmentSubmissionForm,
        child: Center(
          child: ListView(
            children: <Widget>[
              FadeInLTR(
                1,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[screentitleBoldMedium("Add submission")],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 75, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FadeInLTR(
                      1.3,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Submission Description",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Submission Description cannot be empty."
                                  : null,
                              keyboardType: TextInputType.text,
                              onSaved: (value) => submitterDescription = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      1.6,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Submission Sharable Link",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.4,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Submission Sharable cannot be empty."
                                  : null,
                              keyboardType: TextInputType.url,
                              onSaved: (value) => submitterFileLink = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInLTR(
                      1.9,
                      FlatButton(
                        padding: EdgeInsets.all(10),
                        onPressed: validateTheSubmissionForm,
                        child: Text('           Submit           ',
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 18)),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.yellow,
                                width: 0.8,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
