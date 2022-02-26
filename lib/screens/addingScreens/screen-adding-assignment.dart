import '../../components/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import '../../streamproviders.dart';
import '../../components/reusables.dart';

BuildContext globalContext;

class AddAssignmentScreen extends StatefulWidget {
  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  //
  final assignmentForm = GlobalKey<FormState>();

  //
  String subjectName;
  String assignmentDescription;
  String assignmentId;
  DateTime assignmentDueDate;
  TimeOfDay assignmentDueTime;
  DateTime assignmentAssignedDate;
  String assignmentLink;
  String uploadspath;

  // Functions Starts
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != assignmentDueDate) {
      setState(() {
        assignmentDueDate = picked;
      });
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _selectDueTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null && pickedTime != assignmentDueTime) {
      setState(() {
        assignmentDueTime = pickedTime;
        // print(assignmentDueTime);
      });
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _selectAssignedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != assignmentAssignedDate) {
      setState(() {
        assignmentAssignedDate = picked;
        // print(assignmentAssignedDate);
      });
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }
  // Functions Ends

  // Before Submission Check Starts

  bool fieldValidation() {
    if (subjectName.length > 15 || subjectName.isEmpty) return false;
    if (assignmentDescription.length > 50 || assignmentDescription.isEmpty) {
      return false;
    }
    if (isURL(assignmentLink) != true) return false;
    return true;
  }

  bool checkDateAndTimeNullity() {
    if (assignmentDueDate != null &&
        assignmentAssignedDate != null &&
        assignmentDueTime != null) {
      return true;
    } else {
      return false;
    }
  }

  void createUniqueAssignmentID() {
    assignmentId = assignmentDueDate.toString().substring(0, 10) +
        "-" +
        assignmentDueTime.toString().substring(10, 15) +
        "-" +
        DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Before Submission Check End

  // Validate the Form
  void validateTheForm() {
    final assignmentFormData = assignmentForm.currentState;
    assignmentFormData.save();

    if (fieldValidation() == false) {
      showSomeAlerts("Assignment Link is not valid", context);
      return;
    }
    if (checkDateAndTimeNullity() == false) {
      showSomeAlerts("Date and Time cannot be empty", context);
      return;
    }

    if (fieldValidation() != false &&
        fieldValidation() != false &&
        checkDateAndTimeNullity() != false) {
      assignmentFormData.save();
      createUniqueAssignmentID();
      // Fire the storing call
      createAnAssignemnt();
    } else {
      showSomeAlerts("Something is wrong.", context);
      return;
    }
  }

  //

  //Database Work CRUD operation
  void createAnAssignemnt() {
    final sharedpreferencedata =
        Provider.of<SharedPreferencesProviders>(globalContext, listen: false);
    var cacheData = sharedpreferencedata.getAllSharedPreferenceData();
    cacheData.then((cacheItem) => {writeToDatabase(cacheItem[12])});
  }

  void writeToDatabase(String dbPath) async {
    showProgressBar(globalContext);
    final dbqueries =
        Provider.of<DatabaseQueries>(globalContext, listen: false);
    Map<String, dynamic> data = {
      "subjectName": subjectName,
      "assignmentDescription": assignmentDescription,
      "assignmentId": assignmentId,
      "assignmentDueDate": assignmentDueDate.toString().substring(0, 10),
      "assignmentDueTime": assignmentDueTime.toString().substring(10, 15),
      "assignmentAssignedDate":
          assignmentAssignedDate.toString().substring(0, 10),
      "assignmentLink": assignmentLink,
      "active": true,
      "uploads": "/" + dbPath + "/" + assignmentId + "/uploaded"
    };
    var result = dbqueries.setDocumentWithUniqueID(dbPath, assignmentId, data);
    result.then((value) => {
          print("######################################################"),
          print("##### Assignment Data Added to Database #####"),
          print("subjectName            : " + subjectName),
          print("assignmentDescription  : " + assignmentDescription),
          print("assignmentId           : " + assignmentId),
          print("assignmentDueDate      : " +
              assignmentDueDate.toString().substring(0, 10)),
          print("assignmentDueTime      : " +
              assignmentDueTime.toString().substring(10, 15)),
          print("assignmentAssignedDate : " +
              assignmentAssignedDate.toString().substring(0, 10)),
          print("assignmentLink         : " + assignmentLink),
          print("uploads                : " "/" +
              dbPath +
              "/" +
              assignmentId +
              "/uploaded"),
          print("######################################################"),
          showPromisedSomeAlerts(
                  "You have successfully added an assignment. You can see the assignment in the assignment section.",
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
      padding: const EdgeInsets.all(20),
      color: Colors.black87,
      child: Form(
        key: assignmentForm,
        child: Center(
          child: ListView(
            children: <Widget>[
              FadeInLTR(
                1,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      screentitleBoldMedium("Add an assignement")
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 75, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FadeInLTR(
                      1.3,
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Subject Name",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
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
                              style: const TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Subject Name cannot be empty."
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => subjectName = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      1.6,
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Assignment Description",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
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
                              style: const TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Subject Code cannot be empty."
                                  : null,
                              keyboardType: TextInputType.text,
                              onSaved: (value) => assignmentDescription = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      1.9,
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Assigned Date",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                assignmentAssignedDate == null
                                    ? const Text("Date is not selected.")
                                    : Text("${assignmentAssignedDate.toLocal()}"
                                        .split(' ')[0]),
                                RaisedButton(
                                  color: Colors.transparent,
                                  onPressed: () => _selectAssignedDate(context),
                                  child: const Text('Select date'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      2.1,
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Due Date",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    assignmentDueDate == null
                                        ? const Text("Date is not selected.")
                                        : Text("${assignmentDueDate.toLocal()}"
                                            .split(' ')[0]),
                                    RaisedButton(
                                      color: Colors.transparent,
                                      onPressed: () => _selectDueDate(context),
                                      child: const Text('Select date'),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    assignmentDueTime == null
                                        ? const Text("Time is not selected.")
                                        : Text(assignmentDueTime
                                            .toString()
                                            .substring(10, 15)),
                                    RaisedButton(
                                      color: Colors.transparent,
                                      onPressed: () => _selectDueTime(context),
                                      child: const Text('Select Time'),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    FadeInLTR(
                      2.4,
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Assignment Link",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
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
                              style: const TextStyle(color: Colors.white),
                              validator: (value) => value.isEmpty
                                  ? "Assignment Link cannot be empty."
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => assignmentLink = value,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInLTR(
                      2.7,
                      FlatButton(
                        padding: const EdgeInsets.all(10),
                        onPressed: validateTheForm,
                        child: const Text('           Add           ',
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 18)),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
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
