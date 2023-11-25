import 'package:flutter/material.dart';
import 'package:flutter_application_movies/models/searh_model.dart';

class MovieDetails extends StatefulWidget {
  SearchModel searchModel;
  MovieDetails(this.searchModel, {super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  String removeHtmlTags(String htmlText) {
    final pattern = RegExp(r'<[^>]*>');
    return htmlText.replaceAll(pattern, '');
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
        title: const Text('Movie Details'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                widget.searchModel.show?.image?.medium != null
                    ? Container(
                        height: 250,
                        //  width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget
                                    .searchModel.show!.image!.original!))),
                      )
                    : Container(
                        height: 130,
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(widget.searchModel.show!.name ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: [
                  Text(widget.searchModel.show!.genres!.join(', '),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Text(
                  removeHtmlTags(widget.searchModel.show!.summary ?? ''),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    ));
  }
}
