import 'package:flutter/material.dart';
import 'package:test_task/app_database.dart';
import 'package:test_task/entity/note_table.dart';

class MyFutureBuilder extends StatefulWidget {
  MyFutureBuilder({super.key});

  @override
  State<MyFutureBuilder> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyFutureBuilder> {
  AppDatabase? appDatabase;

  @override
  void initState() {
    initializeDatabase();
    super.initState();
  }

  void initializeDatabase() async {
    appDatabase = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    setState(() {}); 
  }

  Future<void> _deleteNoteAt(Note note) async {
    await appDatabase!.noteDao.deleteNoteFormQuery(note.text);
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appDatabase != null
        ? Expanded(
            child: Center(
              child: FutureBuilder<List<Note>>(
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
                          color: Color.fromRGBO(115, 93, 120, 1)
                        ),
                      ),
                    );
                  } else {
                    var notes = snapshot.data!;
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
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
                                  horizontal: 8, vertical: 12
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        style: const TextStyle(
                                          color: Colors.white, fontSize: 18
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
              ),
            ),
          )
        : const Center(
            child: Text(
              'You have no notes yet. Write something :)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(115, 93, 120, 1)
              ),
            ),
          ),
    );
  }
}