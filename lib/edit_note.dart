import 'package:flutter/material.dart';
import 'package:stateisobj/notebook.dart';

class EditNoteScreen extends StatelessWidget {
  final Note _note;

  const EditNoteScreen({super.key, required Note note})
      : _note = note;

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
