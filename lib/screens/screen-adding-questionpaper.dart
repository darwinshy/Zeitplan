import 'package:Zeitplan/components/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import '../streamproviders.dart';
import '../components/reusables.dart';

BuildContext globalContext;

class AddQuestionPaperScreen extends StatefulWidget {
  @override
  _AddQuestionPaperScreenState createState() => _AddQuestionPaperScreenState();
}

class _AddQuestionPaperScreenState extends State<AddQuestionPaperScreen> {
  //
  final questionForm = new GlobalKey<FormState>();

  //
  String questionPaperSubjectName;
  String questionPaperSubjectCode;
  String questionPaperMidEnd;
  int questionPaperSemester;
  String questionPaperYear;
  String tempQuestionPaperYear;
  String questionPaperSubmitterName;
  String questionPaperSubmitterUID;
  String questionPaperUploadDateAndTime;
  String questionPaperLink;

  bool combined = false;

  void switchToCombined(bool value) {
    setState(() {
      combined = value;
      if (value == true) {
        questionPaperSubjectName = "Combined Papers";
        questionPaperSubjectCode = "COMBI";
      } else {
        questionPaperSubjectName = null;
        questionPaperSubjectCode = null;
      }
    });
  }

  @override
  void initState() {
    globalContext = context;
    super.initState();
  }

  // Functions Starts

  void setIndexOfThisSemester(int index) {
    setState(() {
      questionPaperSemester = index;
    });
  }

  void setIndexOfThisSemType(String semType) {
    setState(() {
      questionPaperMidEnd = semType;
    });
  }

  bool fieldValidation() {
    if (questionPaperSubjectName.length > 50 ||
        questionPaperSubjectName.length == 0) {
      showSomeAlerts("Subject Name is not valid or is too long", globalContext);
      return false;
    }
    if (questionPaperSubjectCode.length != 5) {
      showSomeAlerts("Subject Code is not valid", globalContext);
      return false;
    }
    if (questionPaperSemester == null) {
      showSomeAlerts("Please select a semester", globalContext);
      return false;
    }
    if (questionPaperMidEnd == null) {
      showSomeAlerts("Please select a semester type", globalContext);
      return false;
    }

    if (questionPaperYear.length == 0 || questionPaperYear.length == null) {
      showSomeAlerts("Enter a valid Year of Question Paper", globalContext);
      return false;
    }

    if (int.parse(questionPaperYear) < 2012 ||
        int.parse(questionPaperYear) > DateTime.now().year) {
      showSomeAlerts('Enter a year between 2015 and ${DateTime.now().year}',
          globalContext);
      return false;
    }
    if (isURL(questionPaperLink) != true) {
      showSomeAlerts("Enter a valid URL", globalContext);
      return false;
    }
    return true;
  }

  // Before Submission Check End

  // Validate the Form
  void validateTheForm() {
    final questionFormData = questionForm.currentState;
    questionFormData.save();
    if (fieldValidation() != true) {
      return;
    }
    if (questionFormData.validate()) {
      questionFormData.save();
      createAnQuestionPaper();
    } else {
      showSomeAlerts("Something is wrong.", globalContext);
      return;
    }
  }

  //

  //Database Work CRUD operation
  Future<void> setSubjectCodeInTheArray(
      String key, String subject, int sem) async {
    final subjectCodesSnapShot =
        Firestore.instance.document("questionbank/bank").get();
    final dbqueries =
        Provider.of<DatabaseQueries>(globalContext, listen: false);
    Map<String, dynamic> codes;
    var valuesForCodes = {"semesterNumber": sem, "subjectName": subject};

    subjectCodesSnapShot.then((value) => {
          codes = value.data["codes"],
          if (codes.containsKey(key) == false)
            {
              codes.putIfAbsent(key, () => valuesForCodes),
              dbqueries.updateDocument("questionbank", "bank", {"codes": codes})
            }
        });
  }

  void createAnQuestionPaper() {
    String uid;
    String fullname;
    final sharedpreferencedata =
        Provider.of<SharedPreferencesProviders>(globalContext, listen: false);
    var cacheData = sharedpreferencedata.getAllSharedPreferenceData();
    cacheData.then((cacheItem) => {
          uid = cacheItem.elementAt(7),
          fullname = cacheItem.elementAt(0),
          writeToDatabase(uid, fullname, "questionbank/bank/papers"),
        });
  }

  void writeToDatabase(String uid, String fullname, String dbPath) async {
    showProgressBar(globalContext);
    String time = DateTime.now().toString();
    questionPaperSubmitterUID = uid;
    questionPaperSubmitterName = fullname;
    final dbqueries =
        Provider.of<DatabaseQueries>(globalContext, listen: false);
    await setSubjectCodeInTheArray(questionPaperSubjectCode,
        questionPaperSubjectName, questionPaperSemester);
    Map<String, dynamic> data = {
      "questionPaperSubjectName": questionPaperSubjectName,
      "questionPaperSubjectCode": questionPaperSubjectCode,
      "questionPaperMidEnd": questionPaperMidEnd,
      "questionPaperSemester": questionPaperSemester,
      "questionPaperYear": questionPaperYear,
      "questionPaperSubmitterName": questionPaperSubmitterName,
      "questionPaperSubmitterUID": questionPaperSubmitterUID,
      "questionPaperUploadDateAndTime": time,
      "questionPaperLink": questionPaperLink,
    };
    var result = dbqueries.addDocument(dbPath, data);
    result.then((value) => {
          print("######################################################"),
          print("##### Question Data Added to Database #####"),
          print("questionPaperSubjectName      : " + questionPaperSubjectName),
          print("questionPaperSubjectCode      : " + questionPaperSubjectCode),
          print("questionPaperMidEnd           : " + questionPaperMidEnd),
          print("questionPaperSemester         : " +
              questionPaperSemester.toString()),
          print("questionPaperYear             : " +
              questionPaperYear.toString()),
          print(
              "questionPaperSubmitterName    : " + questionPaperSubmitterName),
          print("questionPaperSubmitterUID     : " + questionPaperSubmitterUID),
          print("######################################################"),
          showPromisedSomeAlerts(
                  "You have successfully added a question paper. You can see the question in the question bank section.",
                  globalContext)
              .then((_) =>
                  {Navigator.of(context).pop(), Navigator.of(context).pop()})
        });
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      body: buildForm(),
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black87,
      child: Form(
        key: questionForm,
        child: Center(
          child: ListView(
            children: <Widget>[
              FadeInLTR(
                0.7,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      screentitleBoldMedium("Add a Question Paper"),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FadeInLTR(
                      1,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Combined Paper ?",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            Checkbox(
                                checkColor: Colors.grey[900],
                                value: combined,
                                onChanged: (value) => switchToCombined(value))
                          ],
                        ),
                      ),
                    ),
                    !combined
                        ? FadeInLTR(
                            1.3,
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Subject Name",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter Subject Name",
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
                                    keyboardType: TextInputType.name,
                                    onSaved: (value) =>
                                        questionPaperSubjectName = value,
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    !combined
                        ? FadeInLTR(
                            1.6,
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Subject Code",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText:
                                          "Enter 5 character Subject Code",
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
                                    keyboardType: TextInputType.name,
                                    onSaved: (value) =>
                                        questionPaperSubjectCode =
                                            value.toUpperCase(),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    FadeInLTR(
                      1.9,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Semester",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              crossAxisCount: 4,
                              crossAxisSpacing: 40,
                              children: [
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemester(1);
                                  },
                                  label: Text(
                                    "1st",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: questionPaperSemester == 1
                                      ? Colors.yellow
                                      : Colors.grey[100],
                                ),
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemester(2);
                                  },
                                  label: Text(
                                    "2nd",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: questionPaperSemester == 2
                                      ? Colors.yellow
                                      : Colors.grey[100],
                                ),
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemester(3);
                                  },
                                  label: Text(
                                    "3rd",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: questionPaperSemester == 3
                                      ? Colors.yellow
                                      : Colors.grey[100],
                                ),
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemester(4);
                                  },
                                  label: Text(
                                    "4th",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: questionPaperSemester == 4
                                      ? Colors.yellow
                                      : Colors.grey[100],
                                ),
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemester(5);
                                  },
                                  label: Text(
                                    "5th",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: questionPaperSemester == 5
                                      ? Colors.yellow
                                      : Colors.grey[100],
                                ),
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemester(6);
                                  },
                                  label: Text(
                                    "6th",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: questionPaperSemester == 6
                                      ? Colors.yellow
                                      : Colors.grey[100],
                                ),
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemester(7);
                                  },
                                  label: Text(
                                    "7th",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: questionPaperSemester == 7
                                      ? Colors.yellow
                                      : Colors.grey[100],
                                ),
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemester(8);
                                  },
                                  label: Text(
                                    "8th",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: questionPaperSemester == 8
                                      ? Colors.yellow
                                      : Colors.grey[100],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      2.1,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Semester Type",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemType("Mid Semester");
                                  },
                                  label: Text(
                                    "Mid Semeter",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor:
                                      questionPaperMidEnd == "Mid Semester"
                                          ? Colors.yellow
                                          : Colors.grey[100],
                                ),
                                ActionChip(
                                  onPressed: () {
                                    setIndexOfThisSemType("End Semester");
                                  },
                                  label: Text(
                                    "End Semester",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor:
                                      questionPaperMidEnd == "End Semester"
                                          ? Colors.yellow
                                          : Colors.grey[100],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      2.4,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Question Paper Year",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter Year of the Question Paper",
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
                              keyboardType: TextInputType.number,
                              onSaved: (value) => questionPaperYear = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      2.7,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Assignment Sharable Link",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText:
                                    "Working Link with read-access enabled",
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
                              keyboardType: TextInputType.url,
                              onSaved: (value) => questionPaperLink = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInLTR(
                      3.0,
                      FlatButton(
                        padding: EdgeInsets.all(10),
                        onPressed: validateTheForm,
                        child: Text('           Add           ',
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
