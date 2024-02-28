import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: (query) {
            // This is a simple way to trigger the search. In a real app, you might want to use a more complex state management solution.
            setState(() {});
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Latest Movies'),
            Tab(text: 'Latest TV Shows'),
            Tab(text: 'Top Grossing Movies'),
            Tab(text: 'Top Grossing TV Shows'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MediaList(
              type: 'movie',
              category: 'now_playing',
              query: _searchController.text),
          MediaList(
              type: 'tv', category: 'popular', query: _searchController.text),
          MediaList(
              type: 'movie',
              category: 'popular',
              query: _searchController.text),
          MediaList(
              type: 'tv', category: 'top_rated', query: _searchController.text),
        ],
      ),
    );
  }
}

class MediaList extends StatelessWidget {
  final String type;
  final String category;
  final String query;

  const MediaList(
      {Key? key,
      required this.type,
      required this.category,
      required this.query})
      : super(key: key);

  Future<List<dynamic>> fetchMedia() async {
    const apiKey =
        '8ac4b0da7612dfd2f781452f3d30719a'; // Replace with your TMDB API Key
    String url;
    if (query.isEmpty) {
      url =
          'https://api.themoviedb.org/3/$type/$category?api_key=$apiKey&language=en-US&page=1';
    } else {
      url =
          'https://api.themoviedb.org/3/search/$type?api_key=$apiKey&query=$query&language=en-US&page=1';
    }
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load media');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchMedia(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var media = snapshot.data![index];
              return Card(
                child: Column(
                  children: <Widget>[
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${media['poster_path']}',
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(media['title'] ?? media['name'],
                          style: const TextStyle(fontSize: 14.0),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
