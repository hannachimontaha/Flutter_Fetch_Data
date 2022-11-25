import 'dart:async';
import 'dart:convert';
import 'package:fetch_data/Photo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<List<Photo>> fetchPhoto() async {
  final response = await http.
  get(Uri.parse('https://jsonplaceholder.typicode.com/photos/'));

  if (response.statusCode == 200) {

   Iterable list = jsonDecode(response.body);
   List<Photo> photos = list.map((photojson) => Photo.fromJson(photojson)) .toList();
  return photos;

  } else {

    throw Exception('Failed to load Photos');
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fetch Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Photo>> photo ;
  int _counter = 0;

// INIT LIST
  @override
  void initState() {
    super.initState();
    photo = fetchPhoto();
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // affichage in future builder
        child:FutureBuilder<List<Photo>>(
          future: photo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return (ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].title),
                      trailing: Image.network(snapshot.data![index].url),

                    ),
                  );
                  },
              ));
            } else if (snapshot.hasError) {
              return Text("error");
            } else {
              return const CircularProgressIndicator();
            }
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
