import 'package:flutter/material.dart';

class MovieDetailsPage extends StatelessWidget {
  final Map<String, dynamic> movieData;

  const MovieDetailsPage({Key? key, required this.movieData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = movieData['title'] ??
        movieData['original_title'] ??
        movieData['name'] ??
        'No Title';
    String overview = movieData['overview'] ?? 'No Overview Available';
    String posterPath = movieData['poster_path'] ?? '';
    String releaseDate = movieData['release_date'] ??
        movieData['first_air_date'] ??
        'Unknown Release Date';
    double rating = movieData['vote_average']?.toDouble() ?? 0.0;

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
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the border radius as needed
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
            // Add more widgets to display other movie details like cast, etc.
          ],
        ),
      ),
    );
  }
}
