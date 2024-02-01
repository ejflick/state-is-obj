import 'package:sqflite/sqflite.dart';

abstract class Note {
  Future<void> updateTitle(String newTitle);

  Future<void> updateContent(String newContent);

  String title();

  String content();
}

abstract class Notes {
  Future<Note> createNote();

  Future<Iterable<Note>> iterable();
}

abstract class Notebook {
  Future<Note> createNote();

  Notes notes();
}

final class DbNote implements Note {
  final Database _db;
  final int _id;

  const DbNote(this._db, this._id);

  @override
  Future<void> updateContent(String newContent) async {
    await _db.update('notes', {'content': newContent},
        where: 'id = ?', whereArgs: [_id]);
  }

  @override
  Future<void> updateTitle(String newTitle) async {
    await _db.update('notes', {'title': newTitle},
        where: 'id = ?', whereArgs: [_id]);
  }

  @override
  String content() {
    throw UnimplementedError('Stateless notebook can not retrieve content');
  }

  @override
  String title() {
    throw UnimplementedError('Stateless notebook can not retrieve content');
  }
}

final class DbNotes implements Notes {
  final Database _db;

  const DbNotes(this._db);

  @override
  Future<Note> createNote() async {
    final id = await _db.insert('notes', {'content': '', 'title': ''});
    return CachedNote(DbNote(_db, id), '', '');
  }

  @override
  Future<Iterable<Note>> iterable() async {
    final notes = await _db.query(
        'notes',
        columns: ['id', 'title', 'content']
    );

    return notes.map(
            (row) => CachedNote(
                DbNote(_db, row['id'] as int),
                row['title'] as String,
                row['content'] as String
            )
    ).toList();
  }
}

class CachedNote implements Note {
  final Note _origin;

  String _title;
  String _content;
  bool updated = false;

  CachedNote(this._origin, this._title, this._content);

  @override
  String content() {
    return _content;
  }

  @override
  String title() {
    return _title;
  }

  @override
  Future<void> updateContent(String newContent) async {
    await _origin.updateContent(newContent);
    _content = newContent;
  }

  @override
  Future<void> updateTitle(String newTitle) async {
    await _origin.updateTitle(newTitle);
    _title = newTitle;
  }
}

final class DbNotebook implements Notebook {
  final Database _db;

  const DbNotebook(this._db);

  @override
  Future<Note> createNote() async {
    return await DbNotes(_db).createNote();
  }

  @override
  Notes notes() {
    return DbNotes(_db);
  }
}
