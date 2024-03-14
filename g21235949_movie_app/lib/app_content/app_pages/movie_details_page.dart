import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieDetailsPage extends StatefulWidget {
  final Map<String, dynamic> movieData;
  final String userId; // Assume this is passed from the authentication context

  const MovieDetailsPage(
      {Key? key, required this.movieData, required this.userId})
      : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Future<bool> _isInWatchListFuture;

  @override
  void initState() {
    super.initState();
    _isInWatchListFuture = _checkWatchList();
  }

  Future<bool> _checkWatchList() async {
    final doc = await _db
        .collection('users')
        .doc(widget.userId)
        .collection('watchList')
        .doc(widget.movieData['id'].toString())
        .get();
    return doc.exists;
  }

  void _toggleWatchList(bool isInWatchList) async {
    String movieId = widget.movieData['id'].toString();
    if (isInWatchList) {
      await _db
          .collection('users')
          .doc(widget.userId)
          .collection('watchList')
          .doc(movieId)
          .delete();
    } else {
      await _db
          .collection('users')
          .doc(widget.userId)
          .collection('watchList')
          .doc(movieId)
          .set(widget.movieData);
    }
    setState(() {
      _isInWatchListFuture = _checkWatchList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.movieData['title'] ??
        widget.movieData['original_title'] ??
        widget.movieData['name'] ??
        'No Title';
    String overview = widget.movieData['overview'] ?? 'No Overview Available';
    String posterPath = widget.movieData['poster_path'] ?? '';
    String releaseDate = widget.movieData['release_date'] ??
        widget.movieData['first_air_date'] ??
        'Unknown Release Date';
    double rating = widget.movieData['vote_average']?.toDouble() ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            posterPath.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/original$posterPath',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(
                    height: 250,
                    child: Center(child: Text('No Poster Available')),
                  ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text('Released on: $releaseDate'),
                      ],
                    ),
                  ),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                overview,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            FutureBuilder<bool>(
              future: _isInWatchListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  bool isInWatchList = snapshot.data!;
                  return ElevatedButton(
                    onPressed: () => _toggleWatchList(isInWatchList),
                    child: Text(isInWatchList
                        ? 'Remove from Watch List'
                        : 'Add to Watch List'),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
