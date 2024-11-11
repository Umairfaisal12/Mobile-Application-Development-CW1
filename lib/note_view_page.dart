import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_note_page.dart';
import 'note_model.dart';
import 'database_helper.dart';

class NoteViewPage extends StatelessWidget {
  final Note note;

  NoteViewPage({Key? key, required this.note}) : super(key: key);

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'important', child: Text('Toggle Important')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (value) async {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNotePage(note: note)),
                ).then((_) => Navigator.pop(context)); // Pop to go back after editing
              } else if (value == 'important') {
                note.isImportant = !note.isImportant;
                await DatabaseHelper().updateNote(note);
                Navigator.pop(context);
              } else if (value == 'delete') {
                await DatabaseHelper().deleteNote(note.id!);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              note.description,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            Spacer(),
            // Move the created date to the center of the screen
            Align(
              alignment: Alignment.center,
              child: Text(
                'Created: ${_formatDate(note.dateCreated)}',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                textAlign: TextAlign.center, // Ensures text is centered within the container
              ),
            ),
          ],
        ),
      ),
    );
  }
}
