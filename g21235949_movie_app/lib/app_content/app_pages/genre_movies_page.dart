import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie_details_page.dart';

class GenreMoviesPage extends StatefulWidget {
  final int genreId; // ID of the genre
  final String genreName; // Name of the genre

  const GenreMoviesPage({Key? key, required this.genreId, required this.genreName}) : super(key: key);

  @override
  _GenreMoviesPageState createState() => _GenreMoviesPageState();
}

class _GenreMoviesPageState extends State<GenreMoviesPage> {
  late Future<List<dynamic>> movies; // Future to fetch movies of the genre

  @override
  void initState() {
    super.initState();
    // Fetch movies of the specified genre upon initialization
    movies = fetchMoviesByGenre(widget.genreId);
  }

  // Function to fetch movies by genre ID from the API
  Future<List<dynamic>> fetchMoviesByGenre(int genreId) async {
    const apiKey = 'a1a68143c5f54e5c303e8024bf089ee4'; // TMDB API Key
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

    String userId = "userId"; 

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.genreName} Movies'), // Displaying the genre name in the app bar
      ),
      body: FutureBuilder<List<dynamic>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Displaying error if fetching fails
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
                    // Navigate to movie details page with the necessary userId
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MovieDetailsPage(movieData: movie, userId: userId),
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
                            movie['title'] ?? 'No Title', // Displaying movie title
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
