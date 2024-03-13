import 'package:flutter/material.dart';
import 'package:g21235949_movie_app/app_content/app_pages/genre_movies_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class GenresPage extends StatefulWidget {
  const GenresPage({Key? key}) : super(key: key);

  @override
  _GenresPageState createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  late Future<List<dynamic>> genres;

  @override
  void initState() {
    super.initState();
    genres = fetchGenres();
  }

  Future<List<dynamic>> fetchGenres() async {
    const apiKey = 'a1a68143c5f54e5c303e8024bf089ee4'; // Use your TMDB API Key
    final url = Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey&language=en-US');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['genres'];
    } else {
      throw Exception('Failed to load genres');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Genres'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: genres,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var genre = snapshot.data![index];
                return ListTile(
                  title: Text(genre['name']),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GenreMoviesPage(
                          genreId: genre['id'], genreName: genre['name']),
                    ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
