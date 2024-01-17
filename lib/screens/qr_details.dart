import 'package:bscb/screens/attendance_listing.dart';
import 'package:bscb/screens/home_screen.dart';
import 'package:bscb/services/firebase_service.dart';
import 'package:flutter/material.dart';

class QRDetailsPage extends StatelessWidget {
  final Map<String, dynamic> details;

  const QRDetailsPage({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final name = details['name'];
    final phoneNumber = details["number"];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text('QR Entry Details'),
        actions: [
          IconButton(
            onPressed: () {
              _listAttendance(context);
            },
            icon: Icon(
              Icons.list,
              size: 40,
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .3,
                child: Card(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Card(
                              child: Text(
                            'QR ID: ${details['qrCodeId']}',
                            style: TextStyle(fontSize: 17),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * .04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        width: MediaQuery.of(context).size.width,
                        height: screenHeight * .06,
                        child: Center(
                          child: Text(
                            'NAME: ${name.toString().toUpperCase()}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * .04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        width: MediaQuery.of(context).size.width,
                        height: screenHeight * .06,
                        child: Center(
                          child: Text(
                            'PH: ${phoneNumber}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .08,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    _addAttendance(context);
                  },
                  child: const Text(
                    'ADD ENTRY',
                    style: TextStyle(fontSize: 18, letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addAttendance(BuildContext context) async {
    // Assuming you have access to the qrCodeId in the details map
    String qrCodeId = details['qrCodeId'];

    final String exeption = await FirebaseService().addAttendance(qrCodeId);
    if (exeption.toString() ==
        'Attendance can only be added between 18:00 and 24:00') {
      _showAlreadyEnteredTodayDialog(context);
    } else if (exeption.toString() == 'Attendance already added for today') {
      _showEntryConfirmedDialog(context);
    } else {
      _showEntryConfirmedDialog(context);
    }
  }

  void _showEntryConfirmedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Entry Confirmed',
            style: TextStyle(color: Colors.green),
          ),
          content: const Text('Attendance entry confirmed for today.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlreadyEnteredTodayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Already Entered Today',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Attendance can only be added between 18:00 and 24:00',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _listAttendance(BuildContext context) async {
    String qrCodeId = details['qrCodeId'];
    List<Map<String, dynamic>> attendanceList =
        await FirebaseService().listAttendance(qrCodeId);

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceListPage(
            attendanceList: attendanceList, name: details["name"]),
      ),
    );
  }
}
