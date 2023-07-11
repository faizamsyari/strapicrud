import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void initState() {
    getDataFromStrapi();
    super.initState();
  }

  var dataJson;
  int? total;

  void getDataFromStrapi() async {
    var response =
        await http.get(Uri.parse("http://192.168.1.204:1337/api/mahasiswas"));
    print(response.body);
    var jsonconvert = await json.decode(response.body);
    print(jsonconvert);
    dataJson = jsonconvert;
    setState(() {
      total = jsonconvert["meta"]["pagination"]["total"];
    });
  }

  void deleteDataFromStrapi(int id) async {
    var response = await http
        .delete(Uri.parse("http://192.168.1.204:1337/api/mahasiswas/${id}"));
    print(response.statusCode);
    print("INI ID :${id}");
    getDataFromStrapi();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: total,
        itemBuilder: (context, index) {
          return ListTile(
            title: dataJson == null
                ? Text("Loading Data...")
                : Text(
                    dataJson?["data"]?[index]["attributes"]?["nama_mahasiswa"]),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 27,
              ),
              onPressed: () {
                deleteDataFromStrapi(dataJson["data"][index]["id"]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getDataFromStrapi,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
