import 'package:flutter/material.dart';
import 'add_note_page.dart';
import 'note_view_page.dart';
import 'database_helper.dart';
import 'note_model.dart';
import 'note_search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];
  bool _showImportant = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    List<Note> notes = await DatabaseHelper().getNotes(importantOnly: _showImportant);
    setState(() {
      _notes = notes;
    });
  }

  void _toggleImportant(Note note) async {
    note.isImportant = !note.isImportant;
    await DatabaseHelper().updateNote(note);
    _loadNotes();

    // Show a notification when the note is marked as important
    String message = note.isImportant
        ? 'Note added to Important!'
        : 'Note removed from Important!';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _searchNotes(String query) async {
    List<Note> notes = await DatabaseHelper().getNotes();
    setState(() {
      _notes = notes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              showSearch(context: context, delegate: NoteSearch(onSearch: _searchNotes));
            },
          ),
          IconButton(
            icon: Icon(_showImportant ? Icons.star : Icons.star_border),
            onPressed: () {
              setState(() {
                _showImportant = !_showImportant;
              });
              _loadNotes();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            color: Colors.grey[900],
            child: ListTile(
              title: Text(note.title, style: TextStyle(color: Colors.white)),
              subtitle: Text(note.description, style: TextStyle(color: Colors.white70)),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'important', child: Text('Toggle Important')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddNotePage(note: note)),
                    ).then((_) => _loadNotes());
                  } else if (value == 'important') {
                    _toggleImportant(note);
                  } else if (value == 'delete') {
                    _confirmDelete(context, note);
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteViewPage(note: note)),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0), // Adjusted padding
        child: FloatingActionButton(
          heroTag: 'add_note',
          backgroundColor: Colors.orange,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNotePage()),
            ).then((_) => _loadNotes());
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await DatabaseHelper().deleteNote(note.id!);
      _loadNotes();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note deleted')));
    }
  }
}
