import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/hr_models/fine_model.dart';

class Services {
  Future<List<FineModel>> fetchFines() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('fines')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((e) => FineModel.fromSnapshot(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    } finally {}
  }
}
