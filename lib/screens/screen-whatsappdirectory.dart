import '../components/whatsappDirectory/whatsappList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhatsappScreen extends StatelessWidget {
  Future<List<String>> retriveProfileDetails() async {
    SharedPreferences cacheData = await SharedPreferences.getInstance();
    return [
      //0
      cacheData.getString("fullname").toString(),
      //1
      cacheData.getString("email").toString(),
      //2
      cacheData.getString("phone").toString(),
      //3
      cacheData.getString("scholarId").toString(),
      //4
      cacheData.getString("section").toString(),
      //5
      cacheData.getString("batchYear").toString(),
      //6
      cacheData.getString("branch").toString(),
      //7
      cacheData.getBool("CR").toString(),
      //8
      cacheData.getString("userUID").toString()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: retriveProfileDetails(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              return streamBuildWhatsappDirectoryList(
                  snapshot, retriveProfileDetails, context);
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ));
            }
          }),
    );
  }
}
