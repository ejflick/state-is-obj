final class Note {
  String _title = "";
  String _content = "";

  void updateTitle(String newTitle) {
    _title = newTitle;
  }

  void updateContent(String newContent) {
    _content = newContent;
  }

  String title() => _title;
  String content() => _content;
}

final class Notes {
  final List<Note> _noteList = [];

  Note createNote() {
    Note newNote = Note();

    _noteList.add(newNote);

    return newNote;
  }

  Iterable<Note> iterable() {
    return List.of(_noteList);
  }
}

final class Notebook {
  final Notes _notes = Notes();

  Note createNote() {
    return _notes.createNote();
  }

  Notes notes() => _notes;
}