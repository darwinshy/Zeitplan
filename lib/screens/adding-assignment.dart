import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../streamproviders.dart';
import '../components/reusables.dart';

BuildContext globalContext;

class AddAssignmentScreen extends StatefulWidget {
  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  //
  final assignmentForm = new GlobalKey<FormState>();
  DateFormat formatter = DateFormat('ddMMyyyy');
  //
  String subjectName;
  String assignmentDescription;
  String assignmentId;
  DateTime assignmentDueDate;
  TimeOfDay assignmentDueTime;
  DateTime assignmentAssignedDate;
  String assignmentLink;

  // Functions Starts
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != assignmentDueDate)
      setState(() {
        assignmentDueDate = picked;
      });
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _selectDueTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null && pickedTime != assignmentDueTime) {
      setState(() {
        assignmentDueTime = pickedTime;
        print(assignmentDueTime);
      });
    }
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _selectAssignedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != assignmentAssignedDate)
      setState(() {
        assignmentAssignedDate = picked;
        print(assignmentAssignedDate);
      });
    FocusScope.of(context).requestFocus(new FocusNode());
  }
  // Functions Ends

  // Before Submission Check Starts

  bool checkDateAndTimeNullity() {
    if (assignmentDueDate != null &&
        assignmentAssignedDate != null &&
        assignmentDueTime != null)
      return true;
    else
      return false;
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
    if (checkDateAndTimeNullity() != false && assignmentFormData.validate()) {
      assignmentFormData.save();
      createUniqueAssignmentID();
      createAnAssignemnt();
    } else
      showSomeAlerts("Date and Time cannot be empty", context);
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
      "uploads": []
    };
    var result = dbqueries.setDocumentWithUniqueID(dbPath, assignmentId, data);
    result.then(
        (value) => {Navigator.of(context).pop(), Navigator.of(context).pop()});
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
        key: assignmentForm,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    screentitleBoldMedium("Add an assignement")
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 75, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Subject Name",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
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
                                ? "Subject Name cannot be empty."
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => subjectName = value,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Assignment Description",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
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
                                ? "Subject Code cannot be empty."
                                : null,
                            keyboardType: TextInputType.text,
                            onSaved: (value) => assignmentDescription = value,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Assigned Date",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              assignmentAssignedDate == null
                                  ? Text("Date is not selected.")
                                  : Text("${assignmentAssignedDate.toLocal()}"
                                      .split(' ')[0]),
                              RaisedButton(
                                color: Colors.transparent,
                                onPressed: () => _selectAssignedDate(context),
                                child: Text('Select date'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Due Date",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  assignmentDueDate == null
                                      ? Text("Date is not selected.")
                                      : Text("${assignmentDueDate.toLocal()}"
                                          .split(' ')[0]),
                                  RaisedButton(
                                    color: Colors.transparent,
                                    onPressed: () => _selectDueDate(context),
                                    child: Text('Select date'),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  assignmentDueTime == null
                                      ? Text("Time is not selected.")
                                      : Text(assignmentDueTime
                                          .toString()
                                          .substring(10, 15)),
                                  RaisedButton(
                                    color: Colors.transparent,
                                    onPressed: () => _selectDueTime(context),
                                    child: Text('Select Time'),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Assignment Link",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
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
                                ? "Assignment Link cannot be empty."
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => assignmentLink = value,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      onPressed: validateTheForm,
                      child: Text('           Add           ',
                          style: TextStyle(color: Colors.yellow, fontSize: 18)),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.yellow,
                              width: 0.8,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(20)),
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
