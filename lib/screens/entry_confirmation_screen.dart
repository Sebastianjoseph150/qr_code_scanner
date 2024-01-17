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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('QR Code ID: ${widget.qrCodeId}'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Confirm Entry'),
              ),
            ],
          ),
        ),
      ),
    );
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
      Navigator.pop(context);
    }
  }

  bool isValidFirestoreDocumentPath(String path) {
    return !path.contains('//');
  }
}
