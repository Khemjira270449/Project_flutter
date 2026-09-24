import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant_record_model.dart';
import 'authentication_service.dart';

class DatabaseHelper {
  // Append the username to the collection name
  final collectionName = '${plantRecordModel.CollectionName}_${AuthenticationService.userName}';

  CollectionReference get collection =>
      FirebaseFirestore.instance.collection(collectionName);

  // insert a new plant record
  Future<DocumentReference> addPlantRecord(plantRecordModel plantRecord) async {
    return await collection.add(plantRecord.toJson());
  }
  // update an existing plant record
  Future<void> updatePlantRecord(String id, plantRecordModel plantRecord) async {
    return await collection.doc(id).update(plantRecord.toJson());
  }
  // delete a plant record
  Future<void> deletePlantRecord(String id) async {
    return await collection.doc(id).delete();
  }
  // load all plant records
  Stream<QuerySnapshot> getStreamPlantRecords() {
    return collection.snapshots();
  }  
}