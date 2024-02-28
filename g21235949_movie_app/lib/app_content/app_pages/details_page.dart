import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Assuming this is your Movie model with additional details
class Movie {
  final String title;
  final String posterPath;
  final String overview;
  final double rating;

  Movie({
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.rating,
  });
}

class DetailsScreen extends StatelessWidget {
  final Movie movie;

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(movie.title, style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: movie.posterPath,
              child: Image.network(movie.posterPath),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                movie.overview,
                style: GoogleFonts.lato(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.red),
              title: Text('${movie.rating} / 10', style: GoogleFonts.lato(fontSize: 20)),
            ),
            // Add more widgets as needed for displaying additional movie details
          ],
        ),
      ),
    );
  }
}
