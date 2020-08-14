import 'package:flutter/material.dart';
import 'package:notes/dbhelper/dbHelper.dart';
import 'package:notes/model/note.dart';
import 'package:intl/intl.dart';
import 'package:notes/screens/note_list.dart';
import 'package:share/share.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  final GlobalKey<ScaffoldState> noteListScreenKey;
  NoteDetail(this.note, this.appBarTitle, this.noteListScreenKey);
  @override
  State<StatefulWidget> createState() {
    return _NoteDetailState(
        this.note, this.appBarTitle, this.noteListScreenKey);
  }
}

class _NoteDetailState extends State<NoteDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static var priorities = ['High', 'Low'];
  DbHelper dbHelper = DbHelper();
  Note note;
  String appBarTitle;
  final GlobalKey<ScaffoldState> noteListScreenKey;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  _NoteDetailState(this.note, this.appBarTitle, this.noteListScreenKey);

  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
              icon: Icon(Icons.arrow_back), onPressed: () => {this._save()}),
          actions: [
            Padding(
              padding: EdgeInsets.all(2.0),
              child: IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  this.setState(() {
                    this._save();
                  });
                },
                //  disabledColor: Colors.grey,
              ),
            ),
            (appBarTitle.contains("Edit"))
                ? Padding(
                    padding: EdgeInsets.all(2.0),
                    child: GestureDetector(
                      child: Icon(Icons.share),
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
                        //Navigator.pop(context);
                      },
                      // disabledColor: Colors.grey,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(0.0),
                  ),
            (appBarTitle.contains("Edit"))
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: Icon((note.important == true)
                          ? Icons.star
                          : Icons.star_border),
                      onTap: () {
                        this.setState(() {
                          this.addToImportant(note);
                        });
                      },
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(0.0),
                  ),
            (appBarTitle.contains("Edit"))
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: Icon(Icons.delete),
                      onTap: () {
                        this._delete();
                      },
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(0.0),
                  ),
          ],
        ),
        body: Card(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(15.0),
          // ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                //dropdown menu
                child: ListTile(
                  leading: const Icon(
                    Icons.low_priority,
                    color: Colors.black,
                  ),
                  title: DropdownButton(
                      underline: SizedBox(),
                      items: priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        );
                      }).toList(),
                      value: updatePriorityAsString(note.priority),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      }),
                ),
              ),
              // Second Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                child: TextField(
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  controller: titleController,
                  //  style: textStyle,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(fontSize: 20),
                    focusColor: Colors.black,
                    //  labelText: 'Title',
                    //  labelStyle: textStyle,
                    // icon: Icon(
                    //   Icons.title,
                    //   color: Colors.black,
                    // ),
                  ),
                ),
              ),

              // Third Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    //  labelText: 'Details',
                    hintText: "Note",
                    hintStyle: TextStyle(fontSize: 20.0),
                    border: InputBorder.none,
                    // icon: Icon(
                    //   Icons.details,
                    //   color: Colors.black,
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

//Save
  void _save() async {
    var result;
    moveToLastScreen();
    if (note.title != "" || note.description != null) {
      note.date = DateFormat.yMMMd().format(DateTime.now());
      if (note.id != null) {
        result = await dbHelper.updateNote(note);
      } else {
        result = await dbHelper.insertNote(note);
      }
      statusMessage(result, "Saved");
    }
  }

  //Delete
  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDailog("Info", "Please Add Note");
      return;
    }
    int result = await dbHelper.deleteNote(note.id);
    statusMessage(result, "Deleted");
  }

  void addToImportant(Note note) async {
    note.important = !note.important;
    await dbHelper.updateNote(note);
  }

  //High Low Priority Converter
  void updatePriorityAsInt(String val) {
    switch (val) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
      default:
    }
  }

  String updatePriorityAsString(int val) {
    String priority;
    print(val);
    switch (val) {
      case 1:
        priority = priorities[0];
        break;
      case 2:
        priority = priorities[1];
        break;
    }
    return priority;
  }

  //Navigation
  void moveToLastScreen() {
    //  Navigator.pop(context, true);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return NoteList();
    }), (_) => false);
  }

  //Alert
  void statusMessage(int result, String msg) {
    print(result);
    if (result != 0) {
      _showAlertDailog("Success", "Note $msg");
    } else {
      _showAlertDailog("Error", "Something Wrong");
    }
  }

  void _showAlertDailog(String title, String message) {
    // AlertDialog alertDialog = AlertDialog(
    //   title: Text("Message"),
    //   content: Text(message),
    // );
    // showDialog(context: context, builder: (_) => alertDialog);
    noteListScreenKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}
