import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<dynamic>>? _searchResults;

  Future<List<dynamic>> _performSearch(String query) async {
    const apiKey =
        'a1a68143c5f54e5c303e8024bf089ee4'; // Replace with your TMDB API key
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/multi?api_key=$apiKey&query=$query&language=en-US&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the width for the poster and calculate the height based on the 3:2 aspect ratio for a vertical layout.
    final double posterWidth = 100; // Width of the poster
    final double posterHeight =
        300; // Height of the poster for a 3:2 aspect ratio

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _searchResults = _performSearch(value);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return Card(
                        // Wrap in a Card widget for styling
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          leading: item['poster_path'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      4.0), // Add a slight corner radius
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${item['poster_path']}',
                                    width: posterWidth,
                                    height: posterHeight,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  width: posterWidth,
                                  height: posterHeight,
                                  decoration: BoxDecoration(
                                    color: Colors.grey, // Placeholder color
                                    borderRadius: BorderRadius.circular(
                                        4.0), // Match the image corner radius
                                  ),
                                  child: Icon(Icons.movie,
                                      size: 50), // Placeholder icon
                                ),
                          title:
                              Text(item['title'] ?? item['name'] ?? 'No title'),
                          subtitle: Text(
                              'Release date: ${item['release_date'] ?? item['first_air_date'] ?? 'N/A'}'),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('No results found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
