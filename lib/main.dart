import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
      home: const MyHomePage(title: 'Number Convertor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // ignore: always_put_required_named_parameters_first
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _textController = TextEditingController();

  // ignore: non_constant_identifier_names
  String UserData = '';

  final Map<String, String> numberMap = {
    'zero': '0',
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
  };

  String checkNumbers(String text) {
    final List<String> words = text.toLowerCase().split(' ');
    for (String word in words) {
     if (!numberMap.containsKey(word)) {
        return 'Sorry, "$word" is not a valid word.';
      }
      else{
        return convertTextToNumbers(text);
      }
    }
    return text;
  }

  String convertTextToNumbers(String text) {
    final List<String> words = text.toLowerCase().split(' ');
    // ignore: lines_longer_than_80_chars
    final List<String> numbers = words.map((word) => numberMap[word] ?? word).toList();
    // ignore: avoid_redundant_argument_values
    return numbers.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        // ignore: prefer_int_literals
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: Center(
                  child: Text(UserData, style: const TextStyle(fontSize: 35),),
                ),
              ),
            ),

            TextField(
              maxLength: 10,
              controller: _textController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Write something',
                suffixIcon: IconButton(
                  onPressed: _textController.clear, 
                  icon: const Icon(Icons.clear),),
                ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  UserData = checkNumbers(_textController.text);
                });
              },
              color: Colors.amber,
              child: const Text('Send', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
