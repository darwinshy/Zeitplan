import '../../components/submissions/submissionList.dart';
import '../../classes/classes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../addingScreens/screen-adding-uploadSubmission.dart';
import '../../components/reusables.dart';

BuildContext assignmentDetailViewglobalContext;

class AssignmentDetailView extends StatefulWidget {
  final Assignment record;
  AssignmentDetailView(this.record);

  @override
  _AssignmentDetailViewState createState() => _AssignmentDetailViewState();
}

class _AssignmentDetailViewState extends State<AssignmentDetailView> {
  void uploadYourSubmission() {
    Navigator.of(context).push(PageTransition(
        child: UploadAssignmentScreen(
          widget.record,
        ),
        type: PageTransitionType.fade));
  }

  @override
  Widget build(BuildContext context) {
    assignmentDetailViewglobalContext = context;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Assignment Details",
          style: TextStyle(color: Colors.grey[100], fontSize: 12),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.record.subjectName,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[100],
                                )),
                            InkWell(
                              onTap: uploadYourSubmission,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[100],
                                child: Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AssignmentDetailViewDetails(
                    widget: widget,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  assignmentDetailViewSubmission(widget.record.uploadsPath)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget assignmentDetailViewSubmission(String uploadsCollectionPath) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Current Submissions",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 10,
              fontFamily: "OpenSans",
            )),
        SizedBox(
          height: 8,
        ),
        streamBuildUploadedAssignmentList(
            uploadsCollectionPath, assignmentDetailViewglobalContext)
      ],
    ),
  );
}

class AssignmentDetailViewDetails extends StatelessWidget {
  const AssignmentDetailViewDetails({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final AssignmentDetailView widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assigned Date",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 10,
                      fontFamily: "OpenSans",
                    )),
                SizedBox(
                  height: 8,
                ),
                Text(widget.record.assignmentAssignedDate,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[900],
                    )),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Due Timings",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 10,
                      fontFamily: "OpenSans",
                    )),
                SizedBox(
                  height: 8,
                ),
                Text(
                    widget.record.assignmentDueDate +
                        ", " +
                        giveMePMAM(widget.record.assignmentDueTime),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[900],
                    )),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 10,
                      fontFamily: "OpenSans",
                    )),
                SizedBox(
                  height: 8,
                ),
                Text(widget.record.assignmentDescription,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[900],
                    )),
              ],
            ),
          ],
        ));
  }
}
