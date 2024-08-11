import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseEntryService {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('journal_entries');

  Future<void> addEntry(Map<String, dynamic> entryData) async {
    await collection.add(entryData);
  }

  Future<List<Map<String, dynamic>>> getEntries() async {
    QuerySnapshot querySnapshot =
        await collection.orderBy('createdDate', descending: true).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // Convert 'createdDate' from Timestamp to DateTime if necessary
      if (data['createdDate'] is Timestamp) {
        data['createdDate'] = (data['createdDate'] as Timestamp).toDate();
      }

      return data;
    }).toList();
  }

  Future<void> updateEntry(String id, Map<String, dynamic> updatedData) async {
    await collection.doc(id).update(updatedData);
  }

  Future<void> deleteEntry(String id) async {
    await collection.doc(id).delete();
  }
}

class DatabaseMeditationService {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('favorite_meditations');

  Future<void> addEntry(Map<String, dynamic> entryData) async {
    await collection.add(entryData);
  }

  Future<List<Map<String, dynamic>>> getEntries() async {
    QuerySnapshot querySnapshot =
        await collection.orderBy('createdDate', descending: true).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // Convert 'createdDate' from Timestamp to DateTime if necessary
      if (data['createdDate'] is Timestamp) {
        data['createdDate'] = (data['createdDate'] as Timestamp).toDate();
      }

      return data;
    }).toList();
  }

  Future<void> updateEntry(String id, Map<String, dynamic> updatedData) async {
    await collection.doc(id).update(updatedData);
  }

  Future<void> deleteEntry(String id) async {
    await collection.doc(id).delete();
  }

  Future<void> saveFavoriteMeditation(String title, List<String> steps) async {
    await addEntry({
      'title': title,
      'steps': steps, // Save the list of steps as an array
      'createdDate': FieldValue.serverTimestamp(), // Adds a timestamp
    });
  }
}
