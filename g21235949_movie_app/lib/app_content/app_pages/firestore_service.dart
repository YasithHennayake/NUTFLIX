import 'package:cloud_firestore/cloud_firestore.dart';

class WatchListService {
  final String userId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  WatchListService(this.userId);

  Future<bool> isInWatchList(String movieId) async {
    final doc = await _db
        .collection('users')
        .doc(userId)
        .collection('watchList')
        .doc(movieId)
        .get();
    return doc.exists;
  }

  Future<void> toggleWatchList(Map<String, dynamic> movieData, bool isInWatchList) async {
    String movieId = movieData['id'].toString();
    if (isInWatchList) {
      await _db
          .collection('users')
          .doc(userId)
          .collection('watchList')
          .doc(movieId)
          .delete();
    } else {
      await _db
          .collection('users')
          .doc(userId)
          .collection('watchList')
          .doc(movieId)
          .set(movieData);
    }
  }

  Stream<List<Map<String, dynamic>>> watchListStream() {
    return _db
        .collection('users')
        .doc(userId)
        .collection('watchList')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }
}
