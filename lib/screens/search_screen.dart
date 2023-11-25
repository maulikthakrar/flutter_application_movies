import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_movies/components/custom_search.dart';
import 'package:flutter_application_movies/models/searh_model.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<SearchModel> _searchResults = [];
  String searchTerm = '';

  Future<List<SearchModel>> _search(String searchTerm) async {
    //final searchTerm = _searchController.text.trim();
    //if (searchTerm.isEmpty) return;

    // Make API call using searchTerm
    final apiUrl = 'https://api.tvmaze.com/search/shows?q=$searchTerm';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      _searchResults =
          jsonData.map((item) => SearchModel.fromJson(item)).toList();
      return _searchResults;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Widget _buildProductList(List<SearchModel> searchList) {
    return ListView.builder(
      itemCount: searchList.length,
      itemBuilder: (context, index) {
        SearchModel searchModel = searchList[index];
        return ListTile(
          title: Text(searchModel.show?.name ?? 'No data found',
              style: const TextStyle(color: Colors.white)),
          subtitle: Text(searchModel.show?.type ?? 'No data found',
              style: const TextStyle(color: Colors.white)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: size.height / 12,
          title: TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Products',
                hintStyle: TextStyle(color: Colors.white)),
            onChanged: (value) {
              setState(() {
                searchTerm = value;
              });
            },
          ),
        ),
        body: FutureBuilder<List<SearchModel>>(
          future: _search(searchTerm),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SearchModel> products = snapshot.data!;
              return _buildProductList(products);
            } else if (snapshot.hasError) {
              Error error = snapshot.error as Error;

              if (error is HttpException) {
                HttpException httpError = snapshot.error as HttpException;

                return Text('HTTP Error: ${httpError.message}',
                    style: const TextStyle(color: Colors.white));
              } else if (error is SocketException) {
                return const Text('Network Error',
                    style: TextStyle(color: Colors.white));
              } else {
                return const Text(
                  'Data Error',
                  style: TextStyle(color: Colors.white),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget getColumn() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search',
          ),
          onChanged: (searchTerm) => _search(searchTerm),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              return ListTile(
                title: Text(result.show?.name ?? ' '),
                subtitle: Text(result.show?.type ?? ''),
              );
            },
          ),
        ),
      ],
    );
  }
}
