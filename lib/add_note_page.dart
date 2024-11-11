import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note_model.dart';

class AddNotePage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Note? note;

  AddNotePage({Key? key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      _titleController.text = note!.title;
      _descriptionController.text = note!.description;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: Colors.grey[800],
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (note == null) {
                  final newNote = Note(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dateCreated: DateTime.now().toString(),
                    dateEdited: DateTime.now().toString(),
                  );
                  await DatabaseHelper().insertNote(newNote);
                  _showMessage(context, 'Note added successfully');
                } else {
                  note!.title = _titleController.text;
                  note!.description = _descriptionController.text;
                  note!.dateEdited = DateTime.now().toString();
                  await DatabaseHelper().updateNote(note!);
                  _showMessage(context, 'Note updated successfully');
                }
                Navigator.pop(context);
              },
              child: Text(note == null ? 'Save' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
