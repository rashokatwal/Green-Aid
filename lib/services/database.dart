import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';

class DatabaseService {

  final String? uid;
  final String? sid;
  DatabaseService({ this.uid, this.sid});

  final CollectionReference users = FirebaseFirestore.instance.collection('users'); 
  final CollectionReference scans = FirebaseFirestore.instance.collection('scans');

  Future registerUserData(String firstName, String lastName, String email) async {
    return await users.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'friends': [],
      'savedScans': []
    });
  }

  Future saveScan(String diseaseName, String scannedDate, String description, List<String> symptoms, List<String> preventiveMeasures, String imagePath, {required }) async {
    await scans
        .doc(sid)
        .set({
      'scanId': sid,
      'diseaseName': diseaseName,
      'description': description,
      'symptoms': symptoms,
      'preventiveMeasures': preventiveMeasures,
      'scannedDate': scannedDate,
      'userId': uid,
      'imagePath': imagePath
    });
    await users.doc(uid).update({"savedScans": FieldValue.arrayUnion([sid])});
  }

  Future<void> removeScan() async {
    // Delete the scan by its ID
    // print(scanId);
    // print(uid);
    await scans
        .doc(sid)
        .delete();
    await users.doc(uid).update({"savedScans": FieldValue.arrayRemove([sid])});
  }

  Future getUserData() async {
    return await users.doc(uid).get();
  }

  Future<List<dynamic>> getSavedScans(List<dynamic>? savedScans) async {
    List<dynamic> data = [];
    if (savedScans != null) {
      for (var scan in savedScans) {
        var scanData = await getScanData(scan);
        data.add(scanData);
      }
    }
    // print(data[0]['']);
    return data;
  }

  Future<dynamic> getScanData(dynamic scan) async {
    // Replace with your actual logic to fetch data for a scan
    return await scans.doc(scan).get(); // Example: Just returning the scan for now
  }

}