import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceListPage extends StatelessWidget {
  final List<Map<String, dynamic>> attendanceList;
  final String name;

  AttendanceListPage({required this.attendanceList, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name.toUpperCase(),
          style: TextStyle(letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: attendanceList.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> entry = attendanceList[index];

            // Convert the timestamp to DateTime
            DateTime attendanceTime = DateTime.parse(entry['attendanceTime']);

            // Format the time in 12-hour format without seconds
            String formattedTime = DateFormat('h:mm a').format(attendanceTime);

            return ListTile(
              leading: Text("${index + 1}"),
              title: Text('Date: ${entry['date']}'),
              subtitle: Text('Time: $formattedTime'),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 2,
            );
          },
        ),
      ),
    );
  }
}
