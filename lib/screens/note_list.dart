import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/dbhelper/dbHelper.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:notes/model/note.dart';
import 'note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  //Init DbHelper and variable
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DbHelper dbHelper = DbHelper();
  List<Note> noteList;
  int currentIndex = 0;
  int count = 0;
  bool isGrid = true;
  Note selectedNote = Note("", "", 0, false);
  Widget stackBehindDismiss() {
    return Card(
      child: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }

//Single Note
  Card getSingleTile(Note note, int index) {
    return Card(
      shadowColor: (note.priority == 1) ? Colors.red : Colors.orange,
      borderOnForeground: false,
      // shadowColor: (note.priority == 1) ? Colors.red : Colors.yellow,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: new BorderSide(
            color: Colors.grey,
            width: (selectedNote.id == note.id) ? 3.0 : 1.0,
          )),
      elevation: 4.0,
      child: GestureDetector(
        onTap: () {
          navigateToDetail(note, "Edit Note");
        },
        onLongPress: () {
          this.setState(() {
            selectedNote = note;
            if (selectedNote.id == note.id) {
              settingModalBottomSheet(context, note);
            }
          });
        },
        onDoubleTap: () {
          this.setState(() {
            this.addToImportant(note);
          });
        },
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              note.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ),
          trailing: Icon(
              (note.important == false) ? Icons.star_border : Icons.star,
              size: 30.0,
              color: (note.important == false) ? Colors.black : Colors.yellow),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.date),
                Padding(padding: EdgeInsets.all(2.0)),
                Text((note.description == null)
                    ? " "
                    : note.description.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }

//List View
  ListView renderListView() {
    return ListView.builder(
        itemCount: count,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return getSingleTile(this.noteList[index], index);
        });
  }

//GridView
  StaggeredGridView renderGridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 2.0,
      itemCount: count,
      itemBuilder: (context, index) {
        return getSingleTile(this.noteList[index], index);
      },

      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      // mainAxisSpacing: 4.0,
      crossAxisSpacing: 1.0,
      padding: EdgeInsets.all(0),
    );
  }

  void settingModalBottomSheet(context, Note note) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    onTap: () => this.navigateToDetail(note, "Edit Note")),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text("Share"),
                  onTap: () {
                    if (note.description == null) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Please write something for share"),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      final RenderBox box = context.findRenderObject();
                      Share.share(note.description,
                          subject: note.title,
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    }
                    Navigator.pop(context);
                  },
                ),
                // ListTile(
                //     leading: Icon(Icons.content_copy),
                //     title: Text("Make a Copy"),
                //     onTap: () {
                //       this.setState(() {
                //         this.copyNote(selectedNote);
                //       });
                //     }),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  onTap: () {
                    this.setState(() {
                      this.removeNote(note.id);
                      this.updateListView();
                    });
                  },
                ),
              ],
            ),
          );
        }).whenComplete(() => {
          this.setState(() {
            selectedNote = Note("", "", 0, false);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text(
              'NoteWorthy',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: GestureDetector(
                  child: Icon(
                      (isGrid) ? Icons.format_list_bulleted : Icons.grid_on),
                  onTap: () {
                    this.setState(() {
                      isGrid = !isGrid;
                    });
                  },
                ),
              ),
            ]
            //  backgroundColor: Colors.white,
            ),
        body: Container(
            padding: EdgeInsets.all(5),
            child: (count == 0)
                ? Center(
                    child: Icon(
                      Icons.save_alt,
                      size: 100,
                      color: Colors.grey,
                    ),
                  )
                : (isGrid) ? renderGridView() : renderListView()),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          onPressed: () {
            navigateToDetail(Note('', '', 2, false), 'Add Note');
          },
          child: Icon(
            Icons.add,
            size: 40.0,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          elevation: 6.0,
          backgroundColor: const Color(0xFFFFFBFA),
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black,
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              this.currentIndex = index;
              switch (index) {
                case 0:
                  this.updateListView();
                  break;
                case 1:
                  this.updateListViewWithCat(1);
                  break;
                case 2:
                  this.updateListViewWithCat(2);
                  break;
                case 3:
                  this.updateListViewWithImportant();
                  break;
                default:
                // this.updateListView();
              }
            });
          },
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.view_list), title: Text("All")),
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_upward), title: Text("High")),
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward), title: Text("Low")),
            BottomNavigationBarItem(
                icon: Icon(Icons.star), title: Text("Important"))
          ],
        ));
  }

//Route for Detail Screen
  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title, _scaffoldKey);
    }));

    if (result == true) {
      updateListView();
    }
  }

//Get List
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initilizeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dbHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void updateListViewWithCat(int catId) {
    final Future<Database> dbFuture = dbHelper.initilizeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dbHelper.getNoteListByCat(catId);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void updateListViewWithImportant() {
    final Future<Database> dbFuture = dbHelper.initilizeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dbHelper.getNoteListByImportant(true);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void removeNote(int noteID) {
    dbHelper.deleteNote(noteID);
    // //  this.updateListView();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Note Deleted"),
      duration: Duration(seconds: 2),
    ));
    Navigator.pop(context, true);
  }

  void addToImportant(Note note) async {
    note.important = !note.important;
    await dbHelper.updateNote(note);
    if (currentIndex == 3) {
      this.updateListViewWithImportant();
    }
  }

  // void copyNote(Note note) async {
  //   print(note.title);
  //   if (note.title != "" || note.description != null) {
  //     Note copy;
  //     //copy.title = note.title.toString();
  //     copy.priority = note.priority;
  //     copy.important = note.important;
  //     copy.date = DateFormat.yMMMd().format(DateTime.now());
  //     copy.description = note.description;

  //     print(copy.title);
  //     //var r = await dbHelper.insertNote(selectedNote);
  //     //print(r);
  //   }
  //   Navigator.pop(context);
  // }
}
