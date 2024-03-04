import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:g21235949_movie_app/app_content/app_pages/movie_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<dynamic>>? _searchResults;
  int _searchMode = 0; // 0 for titles, 1 for actors

  Future<List<dynamic>> _performSearch(String query) async {
    const apiKey = 'a1a68143c5f54e5c303e8024bf089ee4'; // API key
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/multi?api_key=$apiKey&query=$query&language=en-US&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<List<dynamic>> searchActors(String query) async {
    const apiKey = 'a1a68143c5f54e5c303e8024bf089ee4'; // API key
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/person?api_key=$apiKey&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> results = json.decode(response.body)['results'];
      if (results.isNotEmpty) {
        return results.first['known_for'];
      }
    }
    throw Exception('Failed to load actor search results');
  }

  @override
  Widget build(BuildContext context) {
    final double posterWidth = 100;
    final double posterHeight = (posterWidth / 2) * 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ToggleButtons(
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Titles'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Actors'),
                  ),
                ],
                isSelected: [_searchMode == 0, _searchMode == 1],
                onPressed: (int index) {
                  setState(() {
                    _searchMode = index;
                  });
                },
              ),
            ],
          ),
        ),
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
                    _searchResults = _searchMode == 0
                        ? _performSearch(value)
                        : searchActors(value);
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
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsPage(movieData: item),
                          ));
                        },
                        child: ListTile(
                          leading: item['poster_path'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
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
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Icon(Icons.movie, size: 50),
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
