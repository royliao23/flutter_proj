import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

import 'homepage.dart'; // Import the homepage file

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 34, 67, 255)),
        ),
        home: MyHomePage(), // Use the home page here
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners(); // Notify UI to rebuild
  }

  
  void updateFavorite(WordPair oldPair, String newValue) {
    int index = favorites.indexOf(oldPair);
    if (index != -1) {
      // Split newValue into two words
      var words = newValue.split(' ');
      String first = words.isNotEmpty ? words[0] : oldPair.first; // First word
      String second = words.length > 1 ? words[1] : oldPair.second; // Second word

      // Update the WordPair
      favorites[index] = WordPair(first, second);
      notifyListeners(); // Notify UI to rebuild
    }
  }
}
