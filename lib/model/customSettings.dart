class CustomSettings {
  int _id;
  String _sort1;
  String _order1;
  String _sort2;
  String _order2;
  String _sort3;
  String _order3;
  String _fieldToDisplay1;
  String _fieldToDisplay2;
  String _fieldToDisplay3;
  String _fieldToDisplay4;
  String _fieldToDisplay5;
  bool _showCompletedTask;

  CustomSettings(
      this._sort1,
      this._order1,
      this._sort2,
      this._order2,
      this._sort3,
      this._order3,
      this._fieldToDisplay1,
      this._fieldToDisplay2,
      this._fieldToDisplay3,
      this._fieldToDisplay4,
      this._fieldToDisplay5,
      this._showCompletedTask);
  CustomSettings.withId(
      this._id,
      this._sort1,
      this._order1,
      this._sort2,
      this._order2,
      this._sort3,
      this._order3,
      this._fieldToDisplay1,
      this._fieldToDisplay2,
      this._fieldToDisplay3,
      this._fieldToDisplay4,
      this._fieldToDisplay5,
      this._showCompletedTask);
  int get id => _id;
  String get sort1 => _sort1;
  String get order1 => _order1;
  String get sort2 => _sort2;
  String get order2 => _order2;
  String get sort3 => _sort3;
  String get order3 => _order3;
  String get fieldToDisplay1 => _fieldToDisplay1;
  String get fieldToDisplay2 => _fieldToDisplay2;
  String get fieldToDisplay3 => _fieldToDisplay3;
  String get fieldToDisplay4 => _fieldToDisplay4;
  String get fieldToDisplay5 => _fieldToDisplay5;
  bool get showCompletedTask => _showCompletedTask;

  set sort1(String newsort1) {
    this._sort1 = newsort1;
  }

  set order1(String neworder1) {
    this._order1 = neworder1;
  }

  set sort2(String newsort2) {
    this._sort2 = newsort2;
  }

  set order2(String neworder2) {
    this._order2 = neworder2;
  }

  set sort3(String newsort3) {
    this._sort3 = newsort3;
  }

  set order3(String neworder3) {
    this._order3 = neworder3;
  }

  set fieldToDisplay1(String newfieldToDisplay1) {
    this._fieldToDisplay1 = newfieldToDisplay1;
  }

  set fieldToDisplay2(String newfieldToDisplay2) {
    this._fieldToDisplay2 = newfieldToDisplay2;
  }

  set fieldToDisplay3(String newfieldToDisplay3) {
    this._fieldToDisplay3 = newfieldToDisplay3;
  }

  set fieldToDisplay4(String newfieldToDisplay4) {
    this._fieldToDisplay4 = newfieldToDisplay4;
  }

  set fieldToDisplay5(String newfieldToDisplay5) {
    this._fieldToDisplay5 = newfieldToDisplay5;
  }

  set showCompletedTask(bool newshowCompletedTask) {
    this._showCompletedTask = newshowCompletedTask;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['sort1'] = _sort1;
    map['order1'] = _order1;
    map['sort2'] = _sort2;
    map['order2'] = _order2;
    map['sort3'] = _sort3;
    map['order3'] = _order3;
    map['fieldToDisplay1'] = _fieldToDisplay1;
    map['fieldToDisplay2'] = _fieldToDisplay2;
    map['fieldToDisplay3'] = _fieldToDisplay3;
    map['fieldToDisplay4'] = _fieldToDisplay4;
    map['fieldToDisplay5'] = _fieldToDisplay5;
    map['showCompletedTask'] = _showCompletedTask;

    if (_id != null) {
      map['id'] = _id;
    }

    return map;
  }

  CustomSettings.fromObject(dynamic o) {
    this._id = o['id'];
    this._sort1 = o['sort1'];
    this._order1 = o['order1'];
    this._sort2 = o['sort2'];
    this._order2 = o['order2'];
    this._sort3 = o['sort3'];
    this._order3 = o['order3'];
    this._fieldToDisplay1 = o['fieldToDisplay1'];
    this._fieldToDisplay2 = o['fieldToDisplay2'];
    this._fieldToDisplay3 = o['fieldToDisplay3'];
    this._fieldToDisplay4 = o['fieldToDisplay4'];
    this._fieldToDisplay5 = o['fieldToDisplay5'];
    this._showCompletedTask = o['showCompletedTask'] == 0 ? false : true;
  }
}
