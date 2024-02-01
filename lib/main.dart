import 'package:flutter/material.dart';
import 'package:stateisobj/edit_note.dart';
import 'package:stateisobj/notebook.dart';

void main() {
  final notebook = Notebook();
  runApp(MyApp(notebook));
}

class MyApp extends StatelessWidget {
  final Notebook _notebook;

  const MyApp(this._notebook, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (context) => HomePage(notebook: _notebook),
        '/edit': (context) {
          final note = ModalRoute.of(context)!.settings.arguments as Note;
          return EditNoteScreen(note: note);
        }
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white70
        )
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Notebook notebook;

  const HomePage({super.key, required this.notebook});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text(
              'Notes',
            ),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [...widget.notebook.notes().iterable().map(notePreview)]
        )
      ),
      floatingActionButton: newNote(),
    );
  }

  Widget newNote() {
    return FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(
            '/edit',
            arguments: widget.notebook.createNote()
        ).then((_) =>
          // Force a redraw after a new note is added.
                setState(() {}
                )
        ),
        label: const Icon(Icons.add)
    );
  }

  Widget notePreview(Note note) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/edit', arguments: note)
          // Force redraw after note has been changed.
          .then((value) => setState((){}));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(note.title().isEmpty ? '(untitled)' : note.title())
            ],
          ),
        ),
      ),
    );
  }
}
