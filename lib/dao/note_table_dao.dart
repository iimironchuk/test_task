import 'package:floor/floor.dart';

import '../entity/note_table.dart';

@dao
abstract class NoteDao {
  @insert
  Future<void> insertNote(Note note);

  @Query('SELECT * FROM notes')
  Future<List<Note>> getAllNotes();

  @delete
  Future<void> deleteNote(Note note);

  @Query('DELETE FROM notes WHERE text=:text')
  Future<void> deleteNoteFormQuery(String text);
}