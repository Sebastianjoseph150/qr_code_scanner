import 'package:bscb/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final timecontroller = TextEditingController();
  final imagecontroller = TextEditingController();

  final team = TextEditingController();

  final match = TextEditingController();

  final FirebaseService services = FirebaseService();

  final snapshot =
      FirebaseFirestore.instance.collection("time").doc("123").snapshots();

  // Add this variable to track whether the data exists in Firestore
  bool dataExists = false;

  // Existing data from Firestore
  String existingMatch = '';
  String existingTeam = '';
  String existingImage = '';

  @override
  void initState() {
    super.initState();

    // Set the initial values of the TextEditingControllers based on Firestore data
    FirebaseFirestore.instance
        .collection("time")
        .doc("123")
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        setState(() {
          dataExists = true;
          existingMatch = snapshot.data()?['match'] ?? '';
          existingTeam = snapshot.data()?['team'] ?? '';
          existingImage = snapshot.data()?['image'] ?? '';

          // Pre-fill the TextFields with existing data

          match.text = existingMatch;
          team.text = existingTeam;
          imagecontroller.text = existingImage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * .25,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(existingImage))),
            ),
            SizedBox(height: 50),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("time")
                  .doc("123")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('Document does not exist');
                }

                // Access data from the snapshot
                String matchValue = snapshot.data!.data()?['match'] ?? '';
                String teamValue = snapshot.data!.data()?['team'] ?? '';
                String image = snapshot.data!.data()?['image'] ?? '';

                int timeIn24HourFormat = snapshot.data!.data()?['time'] ?? 0;

                String formattedTime =
                    convertTo12HourFormat(timeIn24HourFormat);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      adminText("Time", formattedTime),
                      SizedBox(height: 10),
                      adminText("Match", matchValue),
                      SizedBox(height: 10),
                      adminText("Teams", teamValue),
                    ],
                  ),
                );
              },
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    TextField(
                      controller: timecontroller,
                      decoration: const InputDecoration(
                          hintText: 'Enter the time',
                          filled: true,
                          fillColor: Colors.grey,
                          border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: match,
                      decoration: const InputDecoration(
                          hintText: 'Enter Today match ',
                          filled: true,
                          fillColor: Colors.grey,
                          border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: team,
                      decoration: const InputDecoration(
                          hintText: 'teams',
                          filled: true,
                          fillColor: Colors.grey,
                          border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: imagecontroller,
                      decoration: const InputDecoration(
                          hintText: 'image link',
                          filled: true,
                          fillColor: Colors.grey,
                          border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.blueGrey),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Are you sure?"),
                                content:
                                    Text("Do you want to change the details?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        // if(imagecontroller.text.isEmpty || )
                                        services.addTime(
                                            int.parse(timecontroller.text),
                                            team.text,
                                            match.text,
                                            imagecontroller.text);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Submit")),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container adminText(String text, String formattedTime) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Center(
        child: Text(
          '$text: $formattedTime',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  String convertTo12HourFormat(int hourIn24Format) {
    if (hourIn24Format < 0 || hourIn24Format > 23) {
      // Invalid hour, handle accordingly
      return 'Invalid Hour';
    }

    // Determine AM or PM
    String period = (hourIn24Format >= 12) ? 'PM' : 'AM';

    // Convert to 12-hour format
    int hourIn12Format =
        (hourIn24Format > 12) ? hourIn24Format - 12 : hourIn24Format;
    if (hourIn12Format == 0) {
      hourIn12Format = 12; // 12 AM should be displayed as 12, not 0
    }

    // Format as 12-hour time with AM/PM
    String formattedHour = '$hourIn12Format $period';

    return formattedHour;
  }
}
