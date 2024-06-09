import 'package:flutter/material.dart';
import 'package:test_task/app_database.dart';
import 'package:test_task/entity/note_table.dart';
import 'package:test_task/widgets/list_notes.dart';
import 'package:test_task/widgets/no_notes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'My Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _notesController = TextEditingController();
  bool _isTextEntered = true;

  AppDatabase? appDatabase;

  @override
  void initState() {
    initializeDatabase();
    super.initState();
  }

  void initializeDatabase() async {
    appDatabase = await $FloorAppDatabase.databaseBuilder('app_database.dart').build();
    setState(() {});  
  }

  void _addNote() async {
    if (_notesController.text.isEmpty) {
      return;
    }

    final enteredNote = _notesController.text;

    var noteDB = Note(text: enteredNote);
    await appDatabase!.noteDao.insertNote(noteDB);

    setState(() {
      _isTextEntered = true;
    });
    _notesController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _deleteNoteAt(Note note) async {
    await appDatabase!.noteDao.deleteNoteFormQuery(note.text);
    setState(() {});  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(115, 93, 120, 1),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _inputNotes(context),
          const SizedBox(height: 25),
          Expanded(
            child: appDatabase != null
                ? FutureBuilder<List<Note>>(
                    future: appDatabase!.noteDao.getAllNotes(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const NoNotes();
                      } else {
                        var notes = snapshot.data!;
                        return ListNotes(notes: notes, onDismissed: (index) async {
                            await _deleteNoteAt(notes[index]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Note deleted')),
                            );
                        },);
                      }
                    },
                  )
                : const NoNotes(),
          ),
        ],
      ),
    );
  }

  Row _inputNotes(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white70,
          ),
          width: MediaQuery.of(context).size.width * 0.65,
          child: TextField(
            onSubmitted: (value) => _addNote(),
            controller: _notesController,
            onChanged: (value) {
              setState(() {
                _isTextEntered = value.isEmpty;
              });
            },
            decoration: const InputDecoration(
              hintText: 'Add some notes',
            )
          ),
        ),
        IconButton(
          onPressed: _isTextEntered ? null : _addNote,
          icon: const Icon(
            Icons.check,
          ),
        )
      ],
    );
  }
}


