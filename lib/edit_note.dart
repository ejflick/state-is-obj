import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stateisobj/notebook.dart';

class EditNoteScreen extends StatelessWidget {
  final Note _note;

  EditNoteScreen({super.key, required Note note})
      : _note = DebouncedNote(note, 1000);

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController(text: _note.title());
    final contentTextController = TextEditingController(text: _note.content());
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Edit Note',
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => _note.updateTitle(value),
                decoration: const InputDecoration(hintText: 'Title'),
                controller: titleTextController,
              ),
              const SizedBox(height: 5),
              Expanded(
                child: TextFormField(
                  controller: contentTextController,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) => _note.updateContent(value),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(hintText: 'Write note here.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Debounces operations performed on a [Note].
class DebouncedNote implements Note {
  final Note _origin;
  final int _wait;

  Timer? _timer;

  DebouncedNote(Note origin, int wait)
      : _origin = origin, _wait = wait;

  @override
  String content() {
    return _origin.content();
  }

  @override
  String title() {
    return _origin.title();
  }

  @override
  Future<void> updateContent(String newContent) async {
    _timer?.cancel();
    _timer = Timer(
        Duration(milliseconds: _wait),
            () => _origin.updateContent(newContent)
    );
  }

  @override
  Future<void> updateTitle(String newTitle) async {
    _timer?.cancel();
    _timer = Timer(
      Duration(milliseconds: _wait),
          () => _origin.updateTitle(newTitle)
  );
  }

}