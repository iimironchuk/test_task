import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/note_table_dao.dart';
import 'entity/note_table.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 6, entities: [Note])
abstract class AppDatabase extends FloorDatabase {
  NoteDao get noteDao;
}