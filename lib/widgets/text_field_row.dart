import 'package:flutter/material.dart';
import 'package:test_task/app_database.dart';
import 'package:test_task/entity/note_table.dart';

class MyTextFieldRow extends StatefulWidget {
  const MyTextFieldRow({super.key});

  @override
  State<MyTextFieldRow> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyTextFieldRow> {

  final _notesController = TextEditingController();
  //final List<String> _notesList = [];
  bool _isTextEntered = true;

  AppDatabase? appDatabase;

  @override
  void initState() {
    initializeDatabase();
    super.initState();
  }

  void initializeDatabase() async {
    appDatabase =
        await $FloorAppDatabase.databaseBuilder('app_database.dart').build();
  }

  void _addNote() async {
    if (_notesController.text.isEmpty) {
      return;
    }

    final enteredNote = _notesController.text;

    var noteDB = Note(text: enteredNote);
    await appDatabase!.noteDao.insertNote(noteDB);

    setState(() {
      //_notesList.add(enteredNote);
      _isTextEntered = true;
    });
    _notesController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(115, 93, 120, 1),
        title: const Text(
          'My Notes',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    controller: _notesController,
                    onSubmitted: (value) => _addNote(),
                    onChanged: (value) {
                      setState(() {
                        _isTextEntered = value.isEmpty;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Add some notes',
                    )),
              ),
              IconButton(
                onPressed: _isTextEntered ? null : _addNote,
                icon: const Icon(
                  Icons.check,
                ),
              )
            ],
          ),
        ]
      ),
    );
  }
}