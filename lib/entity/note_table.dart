import 'package:floor/floor.dart';

@Entity(tableName: 'notes')
class Note {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String text;

  Note({
    required this.text,
  });
}