import 'package:flutter/material.dart';
import './gallery.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery_Image_App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String keyWord = "";
  TextEditingController editingController = TextEditingController();

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
          title: const Center(
            child: Text(
              'Search your gallery',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Cursive',
                fontSize: 40,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Search images eg. Ball",
                  prefixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      _navigateToGallery();
                    },
                  ),
                ),
                controller: editingController,
                onChanged: (value) {
                  setState(() {
                    keyWord = value;
                  });
                },
                onEditingComplete: () {
                  _navigateToGallery();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Gallery(keyWord: keyWord)),
    );
    editingController.clear();
  }
}
