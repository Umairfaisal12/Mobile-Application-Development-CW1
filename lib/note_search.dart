import 'package:flutter/material.dart';
import 'note_model.dart';
import 'database_helper.dart';
import'note_view_page.dart';

class NoteSearch extends SearchDelegate {
  final Function(String) onSearch;

  // Named parameter for onSearch
  NoteSearch({required this.onSearch});

  List<Note> _searchResults = [];

  Future<void> _performSearch(String query) async {
    _searchResults = await DatabaseHelper().searchNotes(query);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the query when the clear button is pressed
          _searchResults = []; // Clear results
          showSuggestions(context); // Refresh suggestions
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search when the back button is pressed
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _performSearch(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (_searchResults.isEmpty) {
          return Center(child: Text('No notes available in that name'));
        } else {
          return ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final note = _searchResults[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.description),
                onTap: () {
                  close(context, note); // Close search and pass selected note
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoteViewPage(note: note)),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Search for notes...'));
    }

    return FutureBuilder(
      future: _performSearch(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (_searchResults.isEmpty) {
          return Center(child: Text('No notes available in that name'));
        } else {
          return ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final note = _searchResults[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.description),
                onTap: () {
                  close(context, note); // Close search and pass selected note
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoteViewPage(note: note)),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
