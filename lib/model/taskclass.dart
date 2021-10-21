class DisplayTask {
  int? _id;
  String? _main1;
  String? _main2;
  String? _sec1;
  String? _sec2;
  String? _sec3;

  DisplayTask(this._main1, this._main2, this._sec1, this._sec2, this._sec3);
}

class Task {
  int? _id;
  String? _task;
  String? _note;
  String? _dateDue;
  String? _timeDue;
  String? _status;
  String? _priority;
  String? _category;
  String? _action1;
  String? _context1;
  String? _location1;
  String? _tag1;
  String? _goal1;
  String? _priorityText;
  String? _statusText;
  String? _categoryText;
  String? _action1Text;
  String? _context1Text;
  String? _location1Text;
  String? _tag1Text;
  String? _goal1Text;
  int? _isStar;
  int? _isDone;
  String? _dateDone;
  String? _lastModified;
  String? _main1;
  String? _main2;
  String? _sec1;
  String? _sec2;
  String? _sec3;

  Task(
      this._task,
      this._note,
      this._dateDue,
      this._timeDue,
      this._status,
      this._priority,
      this._category,
      this._action1,
      this._context1,
      this._location1,
      this._tag1,
      this._goal1,
      this._isStar,
      this._isDone,
      this._dateDone,
      this._lastModified,
      this._main1,
      this._main2,
      this._sec1,
      this._sec2,
      this._sec3);
  Task.withId(
      this._id,
      this._task,
      this._note,
      this._dateDue,
      this._timeDue,
      this._status,
      this._priority,
      this._category,
      this._action1,
      this._context1,
      this._location1,
      this._tag1,
      this._goal1,
      this._isStar,
      this._isDone,
      this._dateDone,
      this._lastModified,
      this._main1,
      this._main2,
      this._sec1,
      this._sec2,
      this._sec3);
  int? get id => _id;
  String? get task => _task;
  String? get note => _note;
  String? get dateDue => _dateDue;
  String? get timeDue => _timeDue;
  String? get status => _status;
  String? get priority => _priority;
  String? get category => _category;
  String? get action1 => _action1;
  String? get context1 => _context1;
  String? get location1 => _location1;
  String? get tag1 => _tag1;
  String? get goal1 => _goal1;
  String? get statusText => _statusText;
  String? get priorityText => _priorityText;
  String? get categoryText => _categoryText;
  String? get action1Text => _action1Text;
  String? get context1Text => _context1Text;
  String? get location1Text => _location1Text;
  String? get tag1Text => _tag1Text;
  String? get goal1Text => _goal1Text;
  int? get isStar => _isStar;
  int? get isDone => _isDone;
  String? get dateDone => _dateDone;
  String? get lastModified => _lastModified;
  String? get main1 => _main1;
  String? get main2 => _main2;
  String? get sec1 => _sec1;
  String? get sec2 => _sec2;
  String? get sec3 => _sec3;

  set task(String? newTask) {
    this._task = newTask;
  }

  set note(String? newNote) {
    this._note = newNote;
  }

  set dateDue(String? newDatedue) {
    this._dateDue = newDatedue;
  }

  set timeDue(String? newTimedue) {
    this._timeDue = newTimedue;
  }

  set status(String? newStatus) {
    this._status = newStatus;
  }

  set priority(String? newPriority) {
    this._priority = newPriority;
  }

  set category(String? newcategory) {
    this._category = newcategory;
  }

  set action1(String? newaction1) {
    this._action1 = newaction1;
  }

  set context1(String? newcontext1) {
    this._context1 = newcontext1;
  }

  set location1(String? newlocation) {
    this._location1 = newlocation;
  }

  set tag1(String? newTag) {
    this._tag1 = newTag;
  }

  set goal1(String? newGoal) {
    this._goal1 = newGoal;
  }

  set statusText(String? newstatusText) {
    this._statusText = newstatusText;
  }

  set priorityText(String? newpriorityText) {
    this._priorityText = newpriorityText;
  }

  set categoryText(String? newcategoryText) {
    this._categoryText = newcategoryText;
  }

  set action1Text(String? newaction1Text) {
    this._action1Text = newaction1Text;
  }

  set context1Text(String? newcontext1Text) {
    this._context1Text = newcontext1Text;
  }

  set location1Text(String? newlocationText) {
    this._location1Text = newlocationText;
  }

  set tag1Text(String? newTagText) {
    this._tag1Text = newTagText;
  }

  set goal1Text(String? newGoalText) {
    this._goal1Text = newGoalText;
  }

  set isStar(int? newisStar) {
    this._isStar = newisStar;
  }

  set isDone(int? newisDone) {
    this._isDone = newisDone;
  }

  set dateDone(String? newDateDone) {
    this._dateDone = newDateDone;
  }

  set lastModified(String? newLastModified) {
    this._lastModified = newLastModified;
  }

  set main1(String? newMain1) {
    this._main1 = newMain1;
  }

  set main2(String? newMain2) {
    this._main2 = newMain2;
  }

  set sec1(String? newSec1) {
    this._sec1 = newSec1;
  }

  set sec2(String? newSec2) {
    this._sec2 = newSec2;
  }

  set sec3(String? newSec3) {
    this._sec3 = newSec3;
  }

  String colId = 'id';
  String colTask = 'task';
  String colNote = '';
  String colDateDue = '';
  String colTimeDue = '';
  String colStatus = '';
  String colPriority = '';
  String colCategory = '';
  String colAction1 = '';
  String colContext1 = '';
  String colLocation1 = '';
  String colTag1 = '';
  String colGoal1 = '';
  String colIsStar = '';
  String colIsDone = '';
  String colDateDone = '';
  String colLastModified = '';
  String colMain1 = '';
  String colSec1 = '';
  String colSec2 = '';
  String colSec3 = '';

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['task'] = _task;
    map['note'] = _note;
    map['dateDue'] = _dateDue;
    map['timeDue'] = _timeDue;
    map['status'] = _status;
    map['priority'] = _priority;
    map['category'] = _category;
    map['action1'] = _action1;
    map['context1'] = _context1;
    map['location1'] = _location1;
    map['tag1'] = _tag1;
    map['goal1'] = _goal1;
    map['isStar'] = _isStar;
    map['isDone'] = _isDone;
    map['dateDone'] = _dateDone;
    map['lastModified'] = _lastModified;

    if (_id != null) {
      map['id'] = _id;
    }

    return map;
  }

  Task.fromObject(dynamic o) {
    this._id = o['id'];
    this._task = o['task'];
    this._note = o['note'];
    this._dateDue = o['dateDue'];
    this._timeDue = o['timeDue'];
    this._status = o['status'];
    this._priority = o['priority'];
    this._category = o['category'];
    this._action1 = o['action1'];
    this._context1 = o['context1'];
    this._location1 = o['location1'];
    this._tag1 = o['tag1'];
    this._goal1 = o['goal1'];
    this._statusText = o['statusesname'] == null ? "" : o['statusesname'];
    this._priorityText = o['prioritiesname'] == null ? "" : o['prioritiesname'];
    this._categoryText = o['categoriesname'] == null ? "" : o['categoriesname'];
    this._action1Text = o['action1name'] == null ? "" : o['action1name'];
    this._context1Text = o['context1name'] == null ? "" : o['context1name'];
    this._location1Text = o['location1name'] == null ? "" : o['location1name'];
    this._tag1Text = o['tag1name'] == null ? "" : o['tag1name'];
    this._goal1Text = o['goal1name'] == null ? "" : o['goal1name'];
    this._isStar = o['isStar'];
    this._isDone = o['isDone'];
    this._dateDone = o['dateDone'];
    this._lastModified = o['lastModified'];
    this._main1 = o['main1'];
    this._main2 = o['main2'];
    this._sec1 = o['sec1'];
    this._sec2 = o['sec2'];
    this._sec3 = o['sec3'];
  }
}
