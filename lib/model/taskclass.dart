class DisplayTask {
  int _id;
  String _main1;
  String _main2;
  String _sec1;
  String _sec2;
  String _sec3;

  DisplayTask(this._main1, this._main2, this._sec1, this._sec2, this._sec3);
}

class Task {
  int _id;
  String _title;
  String _description;
  String _category;
  String _action1;
  String _context1;
  String _location1;
  String _tag1;
  String _goal1;
  int _priorityvalue;
  String _prioritytext;
  String _dateDue;
  String _timeDue;
  int _isDone;
  String _dateDone;
  String _status;
  String _lastModified;
  String _main1;
  String _main2;
  String _sec1;
  String _sec2;
  String _sec3;

  Task(
      this._title,
      this._description,
      this._category,
      this._action1,
      this._context1,
      this._location1,
      this._tag1,
      this._goal1,
      this._priorityvalue,
      this._prioritytext,
      this._dateDue,
      this._timeDue,
      this._isDone,
      this._dateDone,
      this._status,
      this._lastModified,
      this._main1,
      this._main2,
      this._sec1,
      this._sec2,
      this._sec3);
  Task.withId(
      this._id,
      this._title,
      this._description,
      this._category,
      this._action1,
      this._context1,
      this._location1,
      this._tag1,
      this._goal1,
      this._priorityvalue,
      this._prioritytext,
      this._dateDue,
      this._timeDue,
      this._isDone,
      this._dateDone,
      this._status,
      this._lastModified,
      this._main1,
      this._main2,
      this._sec1,
      this._sec2,
      this._sec3);
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get category => _category;
  String get action1 => _action1;
  String get context1 => _context1;
  String get location1 => _location1;
  String get tag1 => _tag1;
  String get goal1 => _goal1;
  int get priorityvalue => _priorityvalue;
  String get prioritytext => _prioritytext;
  String get dateDue => _dateDue;
  String get timeDue => _timeDue;
  int get isDone => _isDone;
  String get dateDone => _dateDone;
  String get status => _status;
  String get lastModified => _lastModified;
  String get main1 => _main1;
  String get main2 => _main2;
  String get sec1 => _sec1;
  String get sec2 => _sec2;
  String get sec3 => _sec3;

  set title(String newTitle) {
    this._title = newTitle;
  }

  set description(String newDescription) {
    this._description = newDescription;
  }

  set category(String newcategory) {
    this._category = newcategory;
  }

  set action1(String newaction1) {
    this._action1 = newaction1;
  }

  set context1(String newcontext1) {
    this._context1 = newcontext1;
  }

  set location1(String newlocation) {
    this._location1 = newlocation;
  }

  set tag1(String newTag) {
    this._tag1 = newTag;
  }

  set goal1(String newGoal) {
    this._goal1 = newGoal;
  }

  set priorityvalue(int newPriorityv) {
    // if (newPriorityv >= 0 && newPriorityv <= 3) {
    this._priorityvalue = newPriorityv;
    //}
  }

  set prioritytext(String newPriorityt) {
    // if (newPriorityt.length <= 255) {
    this._prioritytext = newPriorityt;
    //}
  }

  set dateDue(String newDatedue) {
    this._dateDue = newDatedue;
  }

  set timeDue(String newTimedue) {
    this._timeDue = newTimedue;
  }

  set isDone(int newisDone) {
    this._isDone = newisDone;
  }

  set dateDone(String newDateDone) {
    this._dateDone = newDateDone;
  }

  set status(String newStatus) {
    this._status = newStatus;
  }

  set lastModified(String newLastModified) {
    this._lastModified = newLastModified;
  }

  set main1(String newMain1) {
    this._main1 = newMain1;
  }

  set main2(String newMain2) {
    this._main2 = newMain2;
  }

  set sec1(String newSec1) {
    this._sec1 = newSec1;
  }

  set sec2(String newSec2) {
    this._sec2 = newSec2;
  }

  set sec3(String newSec3) {
    this._sec3 = newSec3;
  }

  String colId = 'id';
  String colTitle = 'title';
  String colDescription = '';
  String colCategory = '';
  String colAction1 = '';
  String colContext1 = '';
  String colLocation1 = '';
  String colTag1 = '';
  String colGoal1 = '';
  String colPriorityint = '';
  String colPrioritytxt = '';
  String colDateDue = '';
  String colTimeDue = '';
  String colIsDone = '';
  String colDateDone = '';
  String colMain1 = '';
  String colStatus = '';
  String colLastModified = '';

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = _title;
    map['description'] = _description;
    map['category'] = _category;
    map['action1'] = _action1;
    map['context1'] = _context1;
    map['location1'] = _location1;
    map['tag1'] = _tag1;
    map['goal1'] = _goal1;
    map['priorityvalue'] = _priorityvalue;
    map['prioritytext'] = _prioritytext;
    map['dateDue'] = _dateDue;
    map['timeDue'] = _timeDue;
    map['isDone'] = _isDone;
    map['dateDone'] = _dateDone;
    map['status'] = _status;
    map['lastModified'] = _lastModified;

    if (_id != null) {
      map['id'] = _id;
    }

    return map;
  }

  Task.fromObject(dynamic o) {
    this._id = o['id'];
    this._title = o['title'];
    this._description = o['description'];
    this._category = o['category'];
    this._action1 = o['action1'];
    this._context1 = o['context1'];
    this._location1 = o['location1'];
    this._tag1 = o['tag1'];
    this._goal1 = o['goal1'];
    this._priorityvalue = o['priorityvalue'];
    this._prioritytext = o['prioritytext'];
    this._dateDue = o['dateDue'];
    this._timeDue = o['timeDue'];
    this._isDone = o['isDone'];
    this._dateDone = o['dateDone'];
    this._status = o['status'];
    this._lastModified = o['lastModified'];
    this._main1 = o['main1'];
    this._main2 = o['main2'];
    this._sec1 = o['sec1'];
    this._sec2 = o['sec2'];
    this._sec3 = o['sec3'];
  }
}
