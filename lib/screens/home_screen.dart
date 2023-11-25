import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_movies/models/searh_model.dart';
import 'package:flutter_application_movies/screens/movie_details.dart';
import 'package:flutter_application_movies/screens/search_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<SearchModel> movieList;

  @override
  void initState() {
    super.initState();
    movieList = [];
    fetchData();
  }
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Index 0: Home',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 1: Search',
  //     style: optionStyle,
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      }
    });
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        movieList = jsonData.map((item) => SearchModel.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  final ThemeData _myTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black, // Set the background color to black
    ),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      theme: _myTheme,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: size.height / 12,
          backgroundColor: Colors.black,
          title: const Text('Movie List'),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              movieList.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SliverGrid.count(
                      crossAxisCount: 2,
                      children: List.generate(movieList.length, (index) {
                        return Card(
                          color: Colors.black,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MovieDetails(movieList[index])),
                              );
                            },
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                movieList[index].show?.image?.medium != null
                                    ? Expanded(
                                        //height:(MediaQuery.of(context).size.width / 2) -70,
                                        //width: double.infinity,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: movieList[index]
                                              .show!
                                              .image!
                                              .medium!,
                                          // height: 50,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      )
                                    : Container(
                                        height: 130,
                                      ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      movieList[index].show?.name ?? 'No name',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
                    )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search')
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
