class DisplayTask {
  int? _id;
//  String? _main1;
//  String? _main2;
  String? _sec1;
  String? _sec2;
  String? _sec3;

//  DisplayTask(this._main1, this._main2, this._sec1, this._sec2, this._sec3);
  DisplayTask(this._sec1, this._sec2, this._sec3);
}

class Task {
  int? _id;
  String? _task;
  String? _note;
  String? _dateDue;
  String? _timeDue;
  String? _category;
  String? _status;
  String? _priority;
  String? _tag1;
  String? _categoryText;
  String? _statusText;
  String? _priorityText;
  String? _tag1Text;
  int? _isStar;
  int? _isDone;
  String? _dateDone;
  String? _lastModified;
  String? _sec1;
  String? _sec2;
  String? _sec3;

  Task(
      this._task,
      this._note,
      this._dateDue,
      this._timeDue,
      this._category,
      this._status,
      this._priority,
      this._tag1,
      this._isStar,
      this._isDone,
      this._dateDone,
      this._lastModified,
      this._sec1,
      this._sec2,
      this._sec3);
  Task.withId(
      this._id,
      this._task,
      this._note,
      this._dateDue,
      this._timeDue,
      this._category,
      this._status,
      this._priority,
      this._tag1,
      this._isStar,
      this._isDone,
      this._dateDone,
      this._lastModified,
      this._sec1,
      this._sec2,
      this._sec3);
  int? get id => _id;
  String? get task => _task;
  String? get note => _note;
  String? get dateDue => _dateDue;
  String? get timeDue => _timeDue;
  String? get category => _category;
  String? get status => _status;
  String? get priority => _priority;
  String? get tag1 => _tag1;
  String? get categoryText => _categoryText;
  String? get statusText => _statusText;
  String? get priorityText => _priorityText;
  String? get tag1Text => _tag1Text;
  int? get isStar => _isStar;
  int? get isDone => _isDone;
  String? get dateDone => _dateDone;
  String? get lastModified => _lastModified;
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

  set category(String? newcategory) {
    this._category = newcategory;
  }

  set status(String? newStatus) {
    this._status = newStatus;
  }

  set priority(String? newPriority) {
    this._priority = newPriority;
  }

  set tag1(String? newTag) {
    this._tag1 = newTag;
  }

  set categoryText(String? newcategoryText) {
    this._categoryText = newcategoryText;
  }

  set statusText(String? newstatusText) {
    this._statusText = newstatusText;
  }

  set priorityText(String? newpriorityText) {
    this._priorityText = newpriorityText;
  }

  set tag1Text(String? newTagText) {
    this._tag1Text = newTagText;
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
  String colCategory = '';
  String colStatus = '';
  String colPriority = '';
  String colTag1 = '';
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
    map['category'] = _category;
    map['status'] = _status;
    map['priority'] = _priority;
    map['tag1'] = _tag1;
    map['isStar'] = _isStar;
    map['isDone'] = _isDone;
    map['dateDone'] = _dateDone;
    map['lastModified'] = _lastModified;

    if (_id != null) {
      map['id'] = _id;
    }

    return map;
  }

  Map<String, dynamic> toMapNoID() {
    var map = Map<String, dynamic>();
    map['task'] = _task;
    map['note'] = _note;
    map['dateDue'] = _dateDue;
    map['timeDue'] = _timeDue;
    map['category'] = _category;
    map['status'] = _status;
    map['priority'] = _priority;
    map['tag1'] = _tag1;
    map['isStar'] = _isStar;
    map['isDone'] = _isDone;
    map['dateDone'] = _dateDone;
    map['lastModified'] = _lastModified;

    map['id'] = null;

    return map;
  }

  Task.fromObject(dynamic o) {
    this._id = o['id'];
    this._task = o['task'];
    this._note = o['note'];
    this._dateDue = o['dateDue'];
    this._timeDue = o['timeDue'];
    this._category = o['category'];
    this._status = o['status'];
    this._priority = o['priority'];
    this._tag1 = o['tag1'];
    this._categoryText = o['categoriesname'] == null ? "" : o['categoriesname'];
    this._statusText = o['statusesname'] == null ? "" : o['statusesname'];
    this._priorityText = o['prioritiesname'] == null ? "" : o['prioritiesname'];
    this._tag1Text = o['tag1name'] == null ? "" : o['tag1name'];
    this._isStar = o['isStar'];
    this._isDone = o['isDone'];
    this._dateDone = o['dateDone'];
    this._lastModified = o['lastModified'];
    this._sec1 = o['sec1'];
    this._sec2 = o['sec2'];
    this._sec3 = o['sec3'];
  }
}
