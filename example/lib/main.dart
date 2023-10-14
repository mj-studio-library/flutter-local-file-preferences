import 'package:flutter/material.dart';
import 'package:local_file_preferences/local_file_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  var sp = await SharedPreferences.getInstance();
  registerGlobalStorage(SharedPreferencesStorage(sharedPreferences: sp));
  runApp(const MyApp());
}

class LocalFileCounter with LocalFilePrefMixin<int> {
  @override
  int get fallback => 0;

  @override
  String get fileName => 'counter.dat';

  @override
  int fromJson(Map<String, dynamic> json) {
    return json['value'] as int;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'value': value};
  }

  @override
  Duration get throttleDuration => const Duration(milliseconds: 1);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _counter = LocalFileCounter();

  void _incrementCounter() {
    _counter.value += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ValueListenableBuilder(
                valueListenable: _counter,
                builder: (context, value, _) {
                  return Text(
                    '$value',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
