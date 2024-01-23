import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceListPage extends StatelessWidget {
  final List<Map<String, dynamic>> attendanceList;
  final String name;

  AttendanceListPage({required this.attendanceList, required this.name});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            height: 2,
            color: Colors.grey.shade800.withOpacity(0.8),
          ),
        ),
        backgroundColor: Colors.black,
        title: Text(
          name.toUpperCase(),
          style: TextStyle(letterSpacing: screenWidth * 0.01),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ListView.separated(
          itemCount: attendanceList.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> entry = attendanceList[index];

            // Convert the timestamp to DateTime
            DateTime attendanceTime = DateTime.parse(entry['attendanceTime']);

            // Format the time in 12-hour format without seconds
            String formattedTime = DateFormat('h:mm a').format(attendanceTime);

            return ListTile(
              tileColor: Colors.grey.shade900,
              textColor: Colors.white,
              leading: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Text(
                  "${index + 1}",
                  style: TextStyle(fontSize: screenHeight * 0.025),
                ),
              ),
              title: Text(
                'Date: ${DateFormat('dd MMM').format(DateTime.parse(entry['date']))}',
                style: TextStyle(fontSize: screenHeight * 0.018),
              ),
              subtitle: Text(
                'Time: $formattedTime',
                style: TextStyle(fontSize: screenHeight * 0.018),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: screenHeight * 0.002,
            );
          },
        ),
      ),
    );
  }
}
