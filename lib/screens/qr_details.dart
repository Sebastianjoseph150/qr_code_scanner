import 'package:bscb/screens/attendance_listing.dart';
import 'package:bscb/screens/home_screen.dart';
import 'package:bscb/services/firebase_service.dart';
import 'package:flutter/material.dart';

class QRDetailsPage extends StatelessWidget {
  final Map<String, dynamic> details;

  QRDetailsPage({
    super.key,
    required this.details,
  });

  String qrCharacter = '';

  @override
  Widget build(BuildContext context) {
    qrCharacter = details['qrCodeId'][details['qrCodeId'].length - 1];
    debugPrint(qrCharacter.toString());

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final name = details['name'];
    final phoneNumber = details["number"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            height: 2,
            color: Colors.grey.shade800.withOpacity(0.8),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'QR ENTRY DETAILS',
          style: TextStyle(letterSpacing: 1),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _listAttendance(context);
            },
            icon: Icon(
              Icons.list,
              size: screenWidth * 0.1, // Adjust icon size using MediaQuery
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: screenHeight,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight * .6,
                child: Column(
                  children: [
                    Flexible(
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Center(
                          child: Text(
                            qrCharacter == "P" || qrCharacter == "p"
                                ? "VIP"
                                : "NORMAL",
                            style: TextStyle(
                                color: qrCharacter == "P" || qrCharacter == "p"
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * .04),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          border: Border.all(),
                        ),
                        width: screenWidth,
                        height: screenHeight * .06,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.03,
                              ),
                              child: Container(
                                child: Icon(
                                  Icons.person_2_outlined,
                                  size: screenWidth * 0.08,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Container(
                              width: screenWidth * 0.5,
                              child: Text(
                                name,
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  letterSpacing: screenWidth * 0.004,
                                  fontSize: screenHeight * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Spacer(),
                            // Icon(
                            //   Icons.circle,
                            //   size: screenWidth * 0.08,
                            //   color: Colors.amber,
                            // color: qrCharacter   == "P"
                            //     ? Colors.amber.withOpacity(.6)
                            //     : Colors.red.withOpacity(.6),
                            // ),
                            SizedBox(width: screenWidth * 0.02),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * .04),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          border: Border.all(),
                        ),
                        width: screenWidth,
                        height: screenHeight * .06,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.03,
                              ),
                              child: Container(
                                child: Icon(
                                  Icons.phone_android,
                                  size: screenWidth * 0.08,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Center(
                              child: Container(
                                child: Text(
                                  phoneNumber,
                                  style: TextStyle(
                                    letterSpacing: screenWidth * 0.004,
                                    fontSize: screenHeight * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: SizedBox(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            _addAttendance(context);
                          },
                          child: Text(
                            'ADD ENTRY',
                            style: TextStyle(
                              fontSize: screenHeight * 0.018,
                              letterSpacing: screenWidth * 0.004,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.2,
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
      _showAlreadyEnteredTodayDialog(context);
    } else {
      _showEntryConfirmedDialog(context, details['number']);
    }
  }

  void _showEntryConfirmedDialog(
    BuildContext context,
    String number,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.done_sharp,
            color: Colors.green,
            size: 90,
          ),
          title: const Text(
            'Entry Confirmed',
            style: TextStyle(color: Colors.green, fontSize: 30),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final FirebaseService firebaseService = FirebaseService();

                final List<dynamic> message =
                    await firebaseService.fetchData('123');
                print(message);
                final String match = message[0];
                final String team = message[1];
                final String image = message[2];

                firebaseService.sendMessage(
                    details['number'], team, details['name'], match, image);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
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
          backgroundColor: Colors.grey.shade300,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: Icon(
            Icons.dangerous_outlined,
            color: Colors.red,
            size: 90,
          ),

          title: const Text(
            'Already Entered',
            style: TextStyle(color: Colors.red, fontSize: 30),
          ),
          // content: const Text(
          //   'Attendance can only be added between 18:00 and 24:00',
          //   style: TextStyle(color: Colors.black),
          // ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
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
