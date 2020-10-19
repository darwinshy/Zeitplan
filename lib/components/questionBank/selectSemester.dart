import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

Widget selectSemester(void Function(int sem) setSemesterNumber) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "Select Semester",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800)),
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => setSemesterNumber(1),
                    splashColor: Colors.grey[300],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "1st",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setSemesterNumber(2),
                    splashColor: Colors.grey[300],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "2nd",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setSemesterNumber(3),
                    splashColor: Colors.grey[300],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "3rd",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => setSemesterNumber(4),
                    splashColor: Colors.grey[300],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "4th",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setSemesterNumber(5),
                    splashColor: Colors.grey[300],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "5th",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setSemesterNumber(6),
                    splashColor: Colors.grey[300],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "6th",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => setSemesterNumber(7),
                    splashColor: Colors.grey[300],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "7th",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setSemesterNumber(8),
                    splashColor: Colors.grey[300],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "8th",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ))
    ],
  );
}
