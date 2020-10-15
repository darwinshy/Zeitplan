import 'package:flutter/material.dart';

Widget adminTool(String hint, IconData icon, void Function() navigator) {
  return InkWell(
    onTap: navigator,
    child: Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.grey[900],
            size: 50,
          ),
          Text(
            hint,
            style: TextStyle(color: Colors.grey[900]),
          )
        ],
      ),
    ),
  );
}
