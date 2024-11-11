class Note {
  int? id;
  String title;
  String description;
  bool isImportant;
  String dateCreated;
  String dateEdited;

  Note({
    this.id,
    required this.title,
    required this.description,
    this.isImportant = false,
    required this.dateCreated,
    required this.dateEdited,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isImportant': isImportant ? 1 : 0,
      'dateCreated': dateCreated,
      'dateEdited': dateEdited,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isImportant: map['isImportant'] == 1,
      dateCreated: map['dateCreated'],
      dateEdited: map['dateEdited'],
    );
  }
}
