import 'package:notes/model/note.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static DbHelper _dbHelper; //Singleton
  static Database _database; ////Singleton

  String noteTable = 'Note_Tbl';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';
  String colImportant = 'important';

  DbHelper._createInstance();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createInstance();
    }
    return _dbHelper;
  } //Db Instance Checking Which will run at once when you init.

//DbGetter
  Future<Database> get database async {
    if (_database == null) {
      _database = await initilizeDatabase();
    }
    return _database;
  }

  //InitDb
  Future<Database> initilizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return notesDatabase;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,$colDescription TEXT,$colDate TEXT,$colPriority INTEGER,$colImportant BOOLEAN)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //You can also do SQL Query by using db,rowquery
    var result = db.query(noteTable, orderBy: '$colDate DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getNoteMapListWithCat(int catId) async {
    Database db = await this.database;
    //You can also do SQL Query by using db,rowquery
    var result = db.rawQuery(
        'SELECT * FROM $noteTable WHERE $colPriority=$catId  ORDER BY $colDate ASC;');
    // db.query(noteTable,
    // orderBy: '$colDate DESC', where: "$colPriority", whereArgs: ['$catId']);
    return result;
  }

  Future<List<Map<String, dynamic>>> getNoteMapListWithImportant(
      bool important) async {
    Database db = await this.database;
    //You can also do SQL Query by using db,rowquery
    var result = //db.query(noteTable,
        //     orderBy: '$colDate DESC',
        //     where: "$colPriority",
        //     whereArgs: [important]);

        db.rawQuery(
            'SELECT * FROM $noteTable WHERE $colImportant  ORDER BY $colDate ASC;');
    return result;
  }

//Insert
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    note.important = false;
    var result = db.insert(noteTable, note.toMap());
    return result;
  }

//Update
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = db.update(noteTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

//Delete
  Future<int> deleteNote(int noteId) async {
    Database db = await this.database;
    var result = db.rawDelete('DELETE FROM $noteTable WHERE $colId=$noteId');
    // var result = db.delete(noteTable, where: '$colId=?', whereArgs: [noteId]);
    return result;
  }

  //getCount
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT(*) from $noteTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//List
  Future<List<Note>> getNoteList() async {
    var dbNoteList = await getNoteMapList();
    int count = dbNoteList.length;
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(dbNoteList[i]));
    }
    return noteList;
  }

  Future<List<Note>> getNoteListByCat(int catId) async {
    var dbNoteList = await getNoteMapListWithCat(catId);
    int count = dbNoteList.length;
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(dbNoteList[i]));
    }
    return noteList;
  }

  Future<List<Note>> getNoteListByImportant(bool important) async {
    var dbNoteList = await getNoteMapListWithImportant(important);
    int count = dbNoteList.length;
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(dbNoteList[i]));
    }
    return noteList;
  }
}
