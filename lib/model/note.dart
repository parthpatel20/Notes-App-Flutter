class Note {
//Private Variables for class Object
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;
  bool _important;

  //Constructors
  //Add_C
  Note(this._title, this._date, this._priority, _important,
      [this._description]);
  //Edit_C
  Note.forEdit(this._id, this._title, this._date, this._priority, _important,
      [this._description]);

  //Getter
  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;
  bool get important => _important;

  //Setter

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set important(bool newImportant) {
    this._important = newImportant;
  }

  set description(String newDesc) {
    if (newDesc.length <= 255) {
      this._description = newDesc;
    }
  }

  set date(String newDate) {
    if (newDate.length <= 255) {
      this._date = newDate;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  //Map to Db
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;
    map['important'] = (_important == true) ? 1 : 0;
    return map;
  }

  //From Map to Object

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this.date = map['date'];
    this._priority = map['priority'];
    this._important = (map['important'] == 0) ? false : true;
  }
}
