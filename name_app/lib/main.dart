import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
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

  // ↓ Add the code below.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        
      case 1:
        page = FavoritesPage();
      
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Check the available width to decide whether to use NavigationRail or BottomNavigationBar
    var useBottomNav = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Row(
        children: [
          if (!useBottomNav) // Use NavigationRail for wider screens
            SafeArea(
              child: NavigationRail(
                extended: true,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
      // Use BottomNavigationBar for smaller screens
      bottomNavigationBar: useBottomNav
          ? BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
              ],
            )
          : null,
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;

    if (favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    // Define pagination parameters
    const itemsPerPage = 20; // Items per page
    const itemsPerColumn = 10; // Max items per column

    // Determine total pages
    int totalPages = (favorites.length / itemsPerPage).ceil();

    // Determine the start and end index for the current page
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, favorites.length);

    // Get the current page's items
    var pageItems = favorites.sublist(startIndex, endIndex);

    // Split items into columns
    List<List<WordPair>> columns = [];
    for (int i = 0; i < pageItems.length; i += itemsPerColumn) {
      columns.add(pageItems.sublist(
          i, (i + itemsPerColumn).clamp(0, pageItems.length)));
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var column in columns)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var pair in column)
                          ListTile(
                            leading: Icon(Icons.favorite),
                            title: Text(pair.asLowerCase),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Pagination controls
        if (favorites.length > itemsPerPage)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentPage--;
                      });
                    },
                    child: Text('Previous Page'),
                  ),
                Text(
                  'Page ${currentPage + 1} of $totalPages', // Show current page and total pages
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (endIndex < favorites.length)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentPage++;
                      });
                    },
                    child: Text('Next Page'),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary, 
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, style: style, semanticsLabel: "${pair.first} ${pair.second}",),
      ),
    );
  }
}