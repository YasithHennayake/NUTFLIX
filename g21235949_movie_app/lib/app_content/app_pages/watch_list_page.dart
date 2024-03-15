import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WatchListService {
  final String userId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  WatchListService(this.userId);

  // Check if a movie is in the watchlist
  Future<bool> isInWatchList(String movieId) async {
    final doc = await _db
        .collection('users')
        .doc(userId)
        .collection('watchList')
        .doc(movieId)
        .get();
    return doc.exists;
  }

  // Toggle the watchlist status of a movie
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

  // Get the watchlist as a stream of movie data
  Stream<List<Map<String, dynamic>>> watchListStream() {
    return _db
        .collection('users')
        .doc(userId)
        .collection('watchList')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }
}

class WatchListPage extends StatelessWidget {
  final String userId;

  const WatchListPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WatchListService _watchListService = WatchListService(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Watchlist'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _watchListService.watchListStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your watchlist is empty'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var movie = snapshot.data![index];
              return ListTile(
                leading: movie['poster_path'] != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(width: 100, height: 150, child: Icon(Icons.movie)),
                title: Text(movie['title'] ?? 'No Title'),
                subtitle: Text(movie['release_date'] ?? 'Unknown Release Date'),
                onTap: () {
                  
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailsPage(movieData: movie, userId: userId)));
                },
              );
            },
          );
        },
      ),
    );
  }
}
