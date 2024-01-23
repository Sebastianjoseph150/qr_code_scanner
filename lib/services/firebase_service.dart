import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  final CollectionReference qrcodes =
      FirebaseFirestore.instance.collection('qrcodes');
  final String currentname = '';

  static Future<Map<String, dynamic>> getFullDetails(String qrCodeId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('qrCodeId', isEqualTo: qrCodeId)
          .get();

      Map<String, dynamic> details = {};

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        details = document.data() as Map<String, dynamic>;
      }
      return details;
    } catch (e) {
      print('Error fetching details: $e');
      return {};
    }
  }

// adding time
  void addTime(int time, String team, String match, String image) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance.collection('time').doc('123');

      await documentReference
          .set({'time': time, 'team': team, 'match': match, 'image': image});

      print('Document added with ID: ${documentReference.id}');
    } catch (e) {
      print('Error adding or fetching details: $e');
    }
  }

  // fetching time

  Future<int> fetchTimeDetails(String documentId) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance.collection('time').doc(documentId);

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await documentReference.get();

      if (snapshot.exists) {
        // Assuming 'time' is the field you want to retrieve as an integer
        int timeValue = snapshot.data()!['time'] ?? 0;
        return timeValue;
      } else {
        print('Document does not exist');
        return -1; // You can return any default value or handle it accordingly
      }
    } catch (e) {
      print('Error fetching details: $e');
      return -1; // You can return any default value or handle it accordingly
    }
  }

  ///
 
  Future<List<dynamic>> fetchData(String documentId) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance.collection('time').doc(documentId);

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await documentReference.get();

      if (snapshot.exists) {
        String matchValue = snapshot.data()!['match'] ?? '';
        String teamValue = snapshot.data()!['team'] ?? '';
        String imageValue = snapshot.data()!['image'] ?? '';

        return [matchValue, teamValue, imageValue, true];
      } else {
        print('Document does not exist');
        return [
          '',
          '',
          false
        ]; // Return empty strings and false for non-existent document
      }
    } catch (e) {
      print('Error fetching details: $e');
      return [
        '',
        '',
        false
      ]; // Return empty strings and false in case of an error
    }
  }

  ///
  ///
  ///
  ///

  Future<bool> isQREntryAlreadyExists(String qrCodeId) async {
    try {
      QuerySnapshot result =
          await qrcodes.where('qrCodeId', isEqualTo: qrCodeId).get();

      return result.docs.isNotEmpty;
    } catch (e) {
      print('Error checking QR entry existence: $e');
      return false;
    }
  }

  Future<void> saveQREntry({
    required String qrCodeId,
    required String name,
    required String phone,
  }) async {
    try {
      await qrcodes.doc(qrCodeId).set({
        'qrCodeId': qrCodeId,
        'name': name,
        'date': DateTime.now().toString(),
        'number': phone,
      });
    } catch (e) {
      print('Error saving QR entry: $e');
    }
  }

  Future<String> addAttendance(
    String qrCodeId,
  ) async {
    final int time = await fetchTimeDetails('123');

    try {
      DateTime now = DateTime.now();

      if (now.hour >= time) {
        String date = now.toLocal().toString().split(' ')[0];

        String documentId = '$qrCodeId-$date';

        CollectionReference attendanceCollection =
            qrcodes.doc(qrCodeId).collection('attendance');

        QuerySnapshot attendanceQuery =
            await attendanceCollection.where('date', isEqualTo: date).get();

        if (attendanceQuery.docs.isEmpty) {
          await attendanceCollection.doc(documentId).set({
            'qrCodeId': qrCodeId,
            'date': date,
            'attendanceTime': now.toString(),
          });
          return '';
        } else {
          return 'Attendance already added for today';
        }
      } else {
        return 'Attendance can only be added between 18:00 and 24:00';
      }
    } catch (e) {
      return 'Error adding attendance: $e';
    }
  }

  Future<void> sendMessage(String number, String team, String name,
      String match, String image) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var request = http.Request(
      'POST',
      Uri.parse('https://api.ultramsg.com/instance75258/messages/image'),
    );
    final date = DateTime.now();
    final currentday = date.day;
    final currentMonth = date.month;
    final currentyear = date.year;

    request.bodyFields = {
      'token': '9nxslocen5wbe1sv',
      'to': '+91$number',
      'image': image,
      'caption':
          'Greeting from BROTHERS BEKAL\n\nThanks Mr. $name \n\nYour Entry to Bekal Footbal 2024 is confirmed.\n\nMatch: $match\n\nTeam: $team\n\nTime: 8:00 PM\nDate: $currentday/$currentMonth/$currentyear\nStadium: PK GROUPS OF COMPANIES, BEKAL',
    };

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

//
//
//
//
////
  ///
  ///
  Future<List<Map<String, dynamic>>> listAttendance(String qrCodeId) async {
    try {
      CollectionReference attendanceCollection =
          qrcodes.doc(qrCodeId).collection('attendance');

      QuerySnapshot querySnapshot =
          await attendanceCollection.orderBy('date', descending: true).get();

      List<Map<String, dynamic>> attendanceList = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        attendanceList.add(document.data() as Map<String, dynamic>);
      }

      return attendanceList;
    } catch (e) {
      print('Error listing attendance: $e');
      return [];
    }
  }
}
