import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Gallery extends StatefulWidget {
  final String keyWord;
  const Gallery({super.key, required this.keyWord});

  @override
  GalleryState createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  Map<String, dynamic>? imagesData; 
  int currentPage = 1;
  int size = 20;
  int totalPages = 1;
  final ScrollController _scrollController = ScrollController();
  List<dynamic> hits = [];
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    getData(widget.keyWord);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentPage < totalPages && !isLoadingMore) {
          setState(() {
            isLoadingMore = true;
          });
          currentPage++;
          getData(widget.keyWord);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/image0.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('${widget.keyWord}, Page $currentPage/$totalPages',
              style: const TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: imagesData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getCrossAxisCount(context),
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: hits.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  hits[index]['tags'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    hits[index]['previewURL'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(Icons.favorite_border),
                                    Text(" ${hits[index]['likes']} "),
                                    const Icon(Icons.star_border),
                                    Text(" ${hits[index]['favorites']} "),
                                    const Icon(Icons.chat_bubble_outline),
                                    Text(" ${hits[index]['comments']} "),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
      ),
    );
  }

  // func. to cal. no of col
  int getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 6; // lg screen
    } else if (screenWidth > 800) {
      return 4; // md
    } else {
      return 2; // Sm
    }
  }

  void getData(String keyWord) {
    String url =
        "https://pixabay.com/api/?key=46425725-2f57caa1ef758f100aeb16a02&q=$keyWord&page=$currentPage&per_page=$size";
    http.get(Uri.parse(url)).then((onResp) {
      setState(() {
        imagesData = json.decode(onResp.body);
        hits.addAll(imagesData!['hits']);
        totalPages = (imagesData!['totalHits'] / size).ceil();
        isLoadingMore = false;
      });
    }).catchError((onError) {
      debugPrint(onError.toString()); 
    });
  }
}
