import 'package:bscb/services/firebase_service.dart';
import 'package:flutter/material.dart';

class ViewDetailsScreen extends StatefulWidget {
  @override
  _ViewDetailsScreenState createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> {
  List<Map<String, dynamic>> details = [];

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    // List<Map<String, dynamic>> details = await FirebaseService.getFullDetails();
    setState(() {
      this.details = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Details'),
      ),
      body: ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> entry = details[index];
          return
              //  ListTile(
              //   title: Text('QR Code ID: ${entry['qrCodeId']}'),
              //   subtitle: Text('Name: ${entry['name']}'),
              //   // Add more details as needed
              // );
              Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Set your desired background color
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text('QR Code ID: ${entry['qrCodeId']}'),
              subtitle: Text('Name: ${entry['name']}'),
              // Add more details as needed
            ),
          );
        },
      ),
    );
  }
}
