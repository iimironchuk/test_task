import 'package:flutter/material.dart';
import './app_database.dart';
import 'entity/note_table.dart';

void main() {
  runApp(const MyApp());
}

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
    setState(() {});  // Force rebuild to reflect database initialization
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
    setState(() {});  // Force rebuild to update the UI after deletion
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
          Row(
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
          ),
          const SizedBox(height: 25),
          Expanded(
            child: appDatabase != null
                ? FutureBuilder<List<Note>>(
                    future: appDatabase!.noteDao.getAllNotes(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'You have no notes yet. Write something :)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(115, 93, 120, 1),
                            ),
                          ),
                        );
                      } else {
                        var notes = snapshot.data!;
                        return ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Dismissible(
                                direction: DismissDirection.endToStart,
                                key: UniqueKey(),
                                onDismissed: (direction) async {
                                  await _deleteNoteAt(notes[index]);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Note deleted')),
                                  );
                                },
                                background: Container(
                                  color: const Color.fromARGB(183, 244, 67, 54),
                                  child: const Icon(Icons.delete),
                                ),
                                child: Card(
                                  elevation: 0,
                                  color: const Color.fromRGBO(209, 179, 196, 1),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                            notes[index].text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  )
                : const Center(
                    child: Text(
                      'You have no notes yet. Write something :)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(115, 93, 120, 1),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}