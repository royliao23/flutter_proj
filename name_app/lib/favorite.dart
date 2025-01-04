import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

import 'mainentry.dart';

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

    const itemsPerPage = 20;
    const itemsPerColumn = 10;

    int totalPages = (favorites.length / itemsPerPage).ceil();

    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, favorites.length);

    var pageItems = favorites.sublist(startIndex, endIndex);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left
              children: [
                // Text showing the count
                Text(
                  "There are ${favorites.length} items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16), // Add vertical spacing between text and the list
                Row(
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
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Remove the item and update the UI
                                    setState(() {
                                      appState.removeFavorite(pair);
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
                  'Page ${currentPage + 1} of $totalPages',
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
