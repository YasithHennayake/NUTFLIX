//Imported packages
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//Imported pages
import 'package:g21235949_movie_app/app_content/app_pages/movie_genres_list_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/login_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/search_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/movie_details_page.dart';

// Class representing the HomePage
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// State class for the HomePage
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar title
        title: const Center(child: Text('NUTFLIX')),
        titleTextStyle: const TextStyle(
            color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
        actions: <Widget>[
          IconButton(
            // Search icon button.
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to the SearchPage.
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
          ),
        ],
        bottom: TabBar(
          // TabBar for switching between 'Movies' and 'TV Shows'
          controller: _tabController,
          tabs: const [
            Tab(text: 'Movies'),
            Tab(text: 'TV Shows'),
          ],
        ),
      ),
      drawer: Drawer(
        // Drawer for navigation menu.
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),

            ListTile(
              // List tile for navigating to Movie Genres page
              leading: Icon(Icons.movie),
              title: Text('Movie Genres'),
              onTap: () {
                // Close the drawer and navigate to the GenresPage.
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const GenresPage()),
                );
              },
            ),

            // ListTile(
            //   leading: Icon(Icons.tv),
            //   title: Text('TV Show Genres'),
            //   onTap: () {
            //     Navigator.pop(context); // Close the drawer
            //     Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => const  ()),
            //     );
            //   },

            // )

            ListTile(
              // List tile for signing out.
              leading: Icon(Icons.logout),
              title: Text('Sign out'),
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
                // Navigate to the LoginPage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        // TabBarView for displaying content based on selected tab
        controller: _tabController,
        children: [
          CustomScrollView(
            // Tab for displaying movie content
            slivers: <Widget>[
              MediaSliverList(
                  type: 'movie',
                  category: "now_playing",
                  title: "What's on at the cinema?"),
              MediaSliverList(
                  type: 'movie',
                  category: "top_rated",
                  title: "Best movies this year"),
              MediaSliverList(
                  type: 'movie',
                  category: "popular",
                  title: "Highest-grossing movies of all time"),
            ],
          ),
          // Tab for displaying TV show content
          CustomScrollView(
            slivers: <Widget>[
              MediaSliverList(
                  type: 'tv',
                  category: "on_the_air",
                  title: "What's on TV now?"),
              MediaSliverList(
                  type: 'tv',
                  category: "top_rated",
                  title: "Best TV shows this year"),
              MediaSliverList(
                  type: 'tv',
                  category: "popular",
                  title: "Most popular TV shows of all time"),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for displaying a sliver list of media items
class MediaSliverList extends StatelessWidget {
  final String type;
  final String category;
  final String title;

  const MediaSliverList(
      {Key? key,
      required this.type,
      required this.category,
      required this.title})
      : super(key: key);

  // Method to fetch media data from the API
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
                  // Loading indicator while fetching data
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  // Displaying error if data retrieval fail
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  // Displaying list of media items if data is available
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final media = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          // Navigate to the MovieDetailsPage
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsPage(movieData: media),
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
                }
                // Displaying a message if no data is found
                return const Text('No data found');
              },
            ),
          ),
        ],
      ),
    );
  }
}
