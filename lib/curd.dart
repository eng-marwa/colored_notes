import 'package:flutter_day2_iti3/Note.dart';
import 'package:flutter_day2_iti3/constants.dart';
import 'package:flutter_day2_iti3/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class Curd {
  //1- Single instance
  Curd._();

  static final Curd curd = Curd._();

  //2-insert
  Future<int> insertNote(Note note) async {
    Database db = await DbHelper.helper.useDb();
    return await db.insert(tableName, note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    Database db = await DbHelper.helper.useDb();
    List<Map<String, dynamic>> result =
        await db.query(tableName, orderBy: '$colDate desc');
    return result.map((element) => Note.fromMap(element)).toList();
  }

  Future<int> deleteNote(int id) async {
    Database db = await DbHelper.helper.useDb();
    return await db.delete(tableName, where: '$colId=?', whereArgs: [id]);
  }

  Future<int> editNote(Note note) async {
    Database db = await DbHelper.helper.useDb();
    return await db.update(tableName, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
  }
}
