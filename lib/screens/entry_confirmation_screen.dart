import 'package:flutter/material.dart';

class EntryConfirmationScreen extends StatefulWidget {
  final String qrCodeId;
  final Function(String name, String phoneNumber) onConfirmed;

  EntryConfirmationScreen({required this.qrCodeId, required this.onConfirmed});

  @override
  _EntryConfirmationScreenState createState() =>
      _EntryConfirmationScreenState();
}

class _EntryConfirmationScreenState extends State<EntryConfirmationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

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
        title: const Text('REGISTER PASS'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.04,
          right: screenWidth * 0.04,
          top: screenHeight * 0.07,
          bottom: screenHeight * 0.04,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
                color: Colors.grey.shade900,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'ENTER DETAILS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.03,
                          letterSpacing: 1,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: "Enter Name",
                          hintStyle: TextStyle(fontSize: screenHeight * 0.02),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(screenWidth * 0.04),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: "Enter Phone",
                            hintStyle: TextStyle(fontSize: screenHeight * 0.02),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(screenWidth * 0.04),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: validatePhoneNumber
                          // (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter your phone number';
                          //   }
                          //   return null;
                          // },
                          ),
                      SizedBox(height: screenHeight * 0.016),
                      SizedBox(
                        height: screenHeight * 0.06,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 25, 79, 134),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.03,
                              ),
                            ),
                          ),
                          onPressed: () {
                            _submitForm();
                          },
                          child: Text(
                            'REGISTER PASS',
                            style: TextStyle(
                              fontSize: screenHeight * 0.022,
                              color: Colors.grey.shade100,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Check if the entered value is a valid phone number
    String phoneNumber =
        value.replaceAll(RegExp(r'\D'), ''); // Remove non-numeric characters
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
      return 'Please enter a valid 10-digit phone number';
    }

    // You can add more specific checks based on your requirements.
    // For example, you might want to ensure the number starts with a specific digit or follows a certain format.

    return null; // Return null to indicate the input is valid
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!isValidFirestoreDocumentPath(widget.qrCodeId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Invalid QR code',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      widget.onConfirmed(_nameController.text, _phoneNumberController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "REGISTERATION SUCCESSFUL",
            style: TextStyle(fontSize: 25, color: Colors.white.withOpacity(.9)),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30), // Adjust the margin as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  bool isValidFirestoreDocumentPath(String path) {
    return !path.contains('//');
  }
}
