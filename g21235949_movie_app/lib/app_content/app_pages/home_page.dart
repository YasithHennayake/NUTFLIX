
// Importing necessary packages
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Importing other pages
import 'login_page.dart';
import 'movie_genres_list_page.dart';
import 'search_page.dart';
import 'movie_details_page.dart';
import 'watch_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String userId = 'exampleUserId';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all data in SharedPreferences
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('NUTFLIX')),
        titleTextStyle: const TextStyle(
            color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Movies'),
            Tab(text: 'TV Shows'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movie Genres'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GenresPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Watch List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WatchListPage(userId: userId),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign out'),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Your CustomScrollView for Movies
          CustomScrollView(
            slivers: <Widget>[
              MediaSliverList(
                  type: 'movie',
                  category: "now_playing",
                  title: "What's on at the cinema?",
                  userId: userId),
              MediaSliverList(
                  type: 'movie',
                  category: "top_rated",
                  title: "Best movies this year",
                  userId: userId),
              MediaSliverList(
                  type: 'movie',
                  category: "popular",
                  title: "Highest-grossing movies of all time",
                  userId: userId),
            ],
          ),
          // Your CustomScrollView for TV Shows
          CustomScrollView(
            slivers: <Widget>[
              MediaSliverList(
                  type: 'tv',
                  category: "on_the_air",
                  title: "What's on TV now?",
                  userId: userId),
              MediaSliverList(
                  type: 'tv',
                  category: "top_rated",
                  title: "Best TV shows this year",
                  userId: userId),
              MediaSliverList(
                  type: 'tv',
                  category: "popular",
                  title: "Most popular TV shows of all time",
                  userId: userId),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom widget for displaying a sliver list of media items
class MediaSliverList extends StatelessWidget {
  final String type;
  final String category;
  final String title;
  final String userId;

  const MediaSliverList({
    Key? key,
    required this.type,
    required this.category,
    required this.title,
    required this.userId,
  }) : super(key: key);

  // Fetch media items from the API
  Future<List<dynamic>> fetchMedia() async {
    const apiKey = 'a1a68143c5f54e5c303e8024bf089ee4';
    final url = Uri.parse(
        'https://api.themoviedb.org/3/$type/$category?api_key=$apiKey&language=en-US&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load media');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 200.0,
            child: FutureBuilder<List<dynamic>>(
              future: fetchMedia(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No data found'));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final media = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MovieDetailsPage(
                              movieData: media, userId: userId),
                        ));
                      },
                      child: Container(
                        width: 140.0,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${media['poster_path']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  media['title'] ?? media['name'],
                                  style: const TextStyle(fontSize: 14.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

