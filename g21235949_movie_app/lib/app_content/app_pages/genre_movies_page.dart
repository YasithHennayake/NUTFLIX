import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'movie_details_page.dart'; // Ensure this is pointing to your movie details page

class GenreMoviesPage extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreMoviesPage({Key? key, required this.genreId, required this.genreName}) : super(key: key);

  @override
  _GenreMoviesPageState createState() => _GenreMoviesPageState();
}

class _GenreMoviesPageState extends State<GenreMoviesPage> {
  late Future<List<dynamic>> movies;

  @override
  void initState() {
    super.initState();
    movies = fetchMoviesByGenre(widget.genreId);
  }

  Future<List<dynamic>> fetchMoviesByGenre(int genreId) async {
    const apiKey = 'a1a68143c5f54e5c303e8024bf089ee4'; // Use your TMDB API Key
    final url = Uri.parse('https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.genreName} Movies'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var movie = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    // Navigate to movie details page
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MovieDetailsPage(movieData: movie),
                    ));
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie['title'] ?? 'No Title',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
