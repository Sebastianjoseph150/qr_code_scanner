import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference qrcodes =
      FirebaseFirestore.instance.collection('qrcodes');

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

  // Future<String> addAttendance(String qrCodeId) async {
  //   try {
  //     DateTime now = DateTime.now();

  //     if (now.hour >= 18 && now.hour < 24) {
  //       String date = now.toLocal().toString().split(' ')[0];

  //       String documentId = '$qrCodeId-$date';

  //       CollectionReference attendanceCollection =
  //           qrcodes.doc(qrCodeId).collection('attendance');

  //       DocumentSnapshot attendanceSnapshot =
  //           await attendanceCollection.doc(documentId).get();

  //       if (!attendanceSnapshot.exists) {
  //         await attendanceCollection.doc(documentId).set({
  //           'qrCodeId': qrCodeId,
  //           'date': date,
  //           'attendanceTime': now.toString(),
  //         });
  //         return 'Attendance added Successfully';
  //       } else {
  //         return 'Attendance already added for today';
  //       }
  //     } else {
  //       return 'Attendance can only be added between 18:00 and 24:00';
  //     }
  //   } catch (e) {
  //     print('Error adding attendance: $e');
  //     return 'Error adding attendance: $e';
  //   }
  // }

  Future<String> addAttendance(String qrCodeId) async {
    try {
      DateTime now = DateTime.now();

      if (now.hour >= 1 && now.hour < 24) {
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
      print('Error adding attendance: $e');
      return 'Error adding attendance: $e';
    }
  }

  Future<List<Map<String, dynamic>>> listAttendance(String qrCodeId) async {
    try {
      // Construct the subcollection reference
      CollectionReference attendanceCollection =
          qrcodes.doc(qrCodeId).collection('attendance');

      // Query the 'attendance' subcollection and order by date in descending order
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
