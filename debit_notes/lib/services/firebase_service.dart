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
        var field = userDocument.data()?[dataField];
        return field.toString();
      } else {
        return null; // Belge bulunamazsa null döndürür
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }

  Future<List?> getByDocumentAsList(String docId, String dataField) async {
    try {
      var usersCollection = _firestore.collection(collectionName);
      var userDocument = await usersCollection.doc(docId).get();
      if (userDocument.exists) {
        var field = userDocument.data()?[dataField];
        return field;
      } else {
        return null; // Belge bulunamazsa null döndürür
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }

  Future<String?> getDocumentWithInviteCode(
      {required String inviteCodeController}) async {
    try {
      var firebase = FirebaseFirestore.instance;
      var querySnapshot = await firebase
          .collection('groups')
          .where('inviteCode', isEqualTo: inviteCodeController)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String? documentId;
        querySnapshot.docs.forEach((document) {
          print("AAAAAAAAAAAAAAAAAAAAAAAAA id : " + document.id);
          documentId = document.id;
        });
        return documentId;
      } else {
        print('Belge bulunamadı!');
        return null;
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }

  Stream getSnapshot(String docId, String dataField) {
    var docRef = _firestore.collection(collectionName).doc(docId);
    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot[dataField].toString();
      } else {
        return null;
      }
    });
  }

  Future<void> createGroupDocument(
      String name,
      String inviteCode,
      int memberCount,
      String firstFriendName,
      String secondFriendName,
      String ownerName) async {
    try {
      var groupsCollection = _firestore.collection('groups');
      var newGroupRef = groupsCollection.doc();
      await newGroupRef.set({
        'name': name,
        'inviteCode': inviteCode,
        'memberCount': memberCount,
        'members': [ownerName, firstFriendName, secondFriendName],
      });

      // "name" adında bir koleksiyon oluştur
      var nameCollectionRef = newGroupRef.collection(name);
      var user1Ref = nameCollectionRef.doc(firstFriendName);
      var user2Ref = nameCollectionRef.doc(secondFriendName);
      var groupOwnerRef = nameCollectionRef.doc(ownerName);

      // "amounts" adında bir koleksiyon oluştur
      var user1AmountsCol = user1Ref.collection("amounts");
      var user2AmountsCol = user2Ref.collection("amounts");
      var groupOwner = groupOwnerRef.collection("amounts");

      user1Ref.collection("payments");
      user2Ref.collection("payments");
      groupOwnerRef.collection("payments");

      var user1Amounts = user1AmountsCol.doc("debitSum");
      var user2Amounts = user2AmountsCol.doc("debitSum");
      var groupOwnerAmounts = groupOwner.doc("debitSum");

      var user1Debits = user1AmountsCol.doc("userDebits");
      var user2Debits = user2AmountsCol.doc("userDebits");
      var groupOwnerDebits = groupOwner.doc("userDebits");

      await groupOwnerAmounts.set({
        'debitAmountSum': "",
      });

      await user1Amounts.set({
        'debitAmountSum': "",
      });

      await user2Amounts.set({
        'debitAmountSum': "",
      });

      await groupOwnerDebits.set({
        'user1': "",
        'user2': "",
      });

      await user1Debits.set({
        'user1': "",
        'user2': "",
      });

      await user2Debits.set({
        'user1': "",
        'user2': "",
      });
    } catch (e) {
      print('Hata oluştu: $e');
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
