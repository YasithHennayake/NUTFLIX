import 'package:cloud_firestore/cloud_firestore.dart';

class WatchListService {
  final String userId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  WatchListService(this.userId);

  // Check if a movie is in the user's watch list
  Future<bool> isInWatchList(String movieId) async {
    final doc = await _db
        .collection('users')
        .doc(userId)
        .collection('watchList')
        .doc(movieId)
        .get();
    return doc.exists;
  }

  // Toggle a movie in the user's watch list
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

  // Returns a stream of the user's watch list
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
