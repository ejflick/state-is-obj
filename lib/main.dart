import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stateisobj/edit_note.dart';
import 'package:stateisobj/notebook.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await openDatabase(
      'notebook.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'create table notes ('
                'id INTEGER PRIMARY KEY, '
                'title TEXT, '
                'content TEXT)'
        );
      }
  );

  final notebook = DbNotebook(db);

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
        child: FutureBuilder(
          future: widget.notebook.notes().iterable(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  children: [...snapshot.data!.map(notePreview)]
              );
            } else if (snapshot.hasError) {
              debugPrintStack(stackTrace: snapshot.stackTrace);
              return const Center(
                child: Text('Error looking up notes'),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }
        )
      ),
      floatingActionButton: newNote(),
    );
  }

  Widget newNote() {
    return FloatingActionButton.extended(
        onPressed: () async => Navigator.of(context).pushNamed(
            '/edit',
            arguments: (await widget.notebook.createNote())
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
