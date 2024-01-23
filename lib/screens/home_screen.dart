import 'package:bscb/screens/admin_page.dart';
import 'package:flutter/material.dart';
import 'qr_scan_screen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController adminPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 2,
            color: Colors.grey.shade800.withOpacity(0.8),
          ),
        ),
        backgroundColor: Colors.black.withOpacity(.1),
        leading: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.grey.shade400,
                  title: const Text("NO ACCESS (Admin Only)"),
                  content: TextFormField(
                    controller: adminPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Enter Admin password",
                      hintStyle: TextStyle(fontSize: screenHeight * 0.025),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(screenWidth * 0.04),
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (adminPasswordController.text == "0075") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPage(),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Image.asset(
              "assets/images/BSCB.png",

              opacity: const AlwaysStoppedAnimation(.6),
              // width: screenWidth * 0.10,
              // height: screenHeight * 0.2,
            ),
          ),
        ),
        title: Text(
          'BSCB PASS SCANNER',
          style: TextStyle(
            letterSpacing: screenWidth * 0.00090,
            fontSize: screenHeight * 0.03,
            color: Colors.white.withOpacity(.5),
          ),
        ),
        toolbarHeight: screenHeight * 0.09,
      ),
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.12),
              ),
              height: screenHeight * 0.15,
              width: screenWidth * 0.35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QRScanScreen()),
                  );
                },
                child: Icon(
                  Icons.qr_code_scanner,
                  size: screenHeight * 0.06,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
