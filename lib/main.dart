import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Gif {
  final String id;
  final String title;
  final String url;

  Gif({required this.id, required this.title, required this.url});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Gif>> _listadoGifs;

  @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
  }

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(
      Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=9BIpVo9D3v3zQxXYsUNj9gXZaGGT5u8P&limit=10&offset=0&rating=g&bundle=messaging_non_clips"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Gif> gifs = [];

      for (var gifData in jsonData['data']) {
        Gif gif = Gif(
          id: gifData['id'],
          title: gifData['title'],
          url: gifData['images']['original']['url'],
        );
        gifs.add(gif);
      }

      return gifs;
    } else {
      throw Exception("Fallo la conexión");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIF App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('GIF App'),
        ),
        body: FutureBuilder<List<Gif>>(
          future: _listadoGifs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                    
                    },
                    child: Image.network(
                      snapshot.data![index].url,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
