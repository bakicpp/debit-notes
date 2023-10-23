import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollectionService<T> {
  final String collectionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseCollectionService(this.collectionName);

  Future<List<T>> getAll() async {
    final snapshot = await _firestore.collection(collectionName).get();
    return snapshot.docs.map((doc) => doc.data() as T).toList();
  }

  Future<T> getById(String id) async {
    final snapshot = await _firestore.collection(collectionName).doc(id).get();

    if (snapshot.exists) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data as T;
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<String?> getByDocument(String docId, String dataField) async {
    try {
      var usersCollection = _firestore.collection(collectionName);
      var userDocument = await usersCollection.doc(docId).get();
      if (userDocument.exists) {
        var field = userDocument.data()?[dataField] as String?;
        return field;
      } else {
        return null; // Belge bulunamazsa null döndürür
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }

  Future<void> add(T item) async {
    await _firestore
        .collection(collectionName)
        .add(item as Map<String, dynamic>);
  }

  Future<void> update(String id, T item) async {
    await _firestore
        .collection(collectionName)
        .doc(id)
        .update(item as Map<Object, Object?>);
  }

  Future<void> delete(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}
