import 'package:flutter/material.dart';
import 'package:test_task/entity/note_table.dart';
import 'package:test_task/main.dart';

class ListNotes extends StatelessWidget {
  const ListNotes({super.key, required this.notes, required this.onDismissed,});

  final List<Note> notes;
  final IntCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Center(
          child: Dismissible(
            direction: DismissDirection.endToStart,
            key: UniqueKey(),
            onDismissed: (direction) async {
              onDismissed.call(index);
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
}