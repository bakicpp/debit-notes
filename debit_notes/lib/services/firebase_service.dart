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
    return snapshot.data() as T;
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
