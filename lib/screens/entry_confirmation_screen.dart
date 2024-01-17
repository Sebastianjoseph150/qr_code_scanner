import 'package:flutter/material.dart';

class EntryConfirmationScreen extends StatefulWidget {
  final String qrCodeId;
  final Function(String name, String phoneNumber) onConfirmed;

  EntryConfirmationScreen({required this.qrCodeId, required this.onConfirmed});

  @override
  _EntryConfirmationScreenState createState() => _EntryConfirmationScreenState();
}

class _EntryConfirmationScreenState extends State<EntryConfirmationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Confirmation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('QR Code ID: ${widget.qrCodeId}'),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Confirm Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, call the onConfirmed callback
      widget.onConfirmed(_nameController.text, _phoneNumberController.text);
      Navigator.pop(context);
    }
  }
}
