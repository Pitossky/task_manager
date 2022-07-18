import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final firestoreServiceInstance = FirestoreService._();

  Future<void> setData({
    required String dbPath,
    required String uid,
    required Map<String, dynamic> dbData,
  }) async {
    if (dbPath.contains("users/$uid/entries")) {
      final reference = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("entries")
          .doc(dbData["taskId"]);
      print('$dbPath: $dbData');
      await reference.set(dbData);
    } else {
      final reference = FirebaseFirestore.instance.doc(dbPath);
      print('$dbPath: $dbData');
      await reference.set(dbData);
    }
  }

  Future<void> deleteData({required String docPath}) async {
    final reference = FirebaseFirestore.instance.doc(docPath);
    print('delete: $docPath');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(
      Map<String, dynamic> data,
      String documentId,
    )
        builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(
                snapshot.data() as Map<String, dynamic>,
                snapshot.id,
              ))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(
      Map<String, dynamic>? data,
      String documentID,
    )
        builder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(
          snapshot.data(),
          snapshot.id,
        ));
  }
}
