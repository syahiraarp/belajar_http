import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



 Future<List<Cat>> fetchRandomCat() async{
    final response = await http.get(Uri.parse('http://api.thecatapi.com/v1/images/search'));

    if (response.statusCode == 200) {
      return List<Cat>.from(
        json.decode(response.body).map((cat) => Cat.fromJson(cat)),
      );
    } else {
      throw Exception('Failed to load cat');
    }
  }

  Future<List<Cat>> fetchListOfCat() async {
    final response = await http.get(Uri.parse('http://api.thecatapi.com/v1/images/search?limit=10'),);
     if (response.statusCode == 200) {
      return List<Cat>.from(
        json.decode(response.body).map((cat) => Cat.fromJson(cat)),
      );
    } else {
      throw Exception('Failed to load cat');
    }
  }

class Cat {
  final String id;
  final String url;
  final int width;
  final int height;


  Cat({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late Future<Album> futureAlbum;
  // late Future<ChukNorris> futureChuckNorris;
  late Future<List<Cat>> futureListOfCat;

  @override
  void initState() {
    super.initState();
    // futureAlbum = fetchAlbum();
    // futureChuckNorris = fetchChuckNorris();
    futureListOfCat = fetchRandomCat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Cat>>(
            future: fetchListOfCat(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder:(context, index) {
                    return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                      Image.network(snapshot.data![index].url),
                      ListTile(
                        leading: const Icon(Icons.pets),
                        title: Text(snapshot.data![index].id),
                        subtitle: Text('Width: ${snapshot.data![index].width} Height: ${snapshot.data![index].height}'),
                      )
                    ],
                  ),
                );
                  }); 
                
                   
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}