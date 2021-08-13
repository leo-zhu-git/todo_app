class CustomSettings {
  int _id;
  String _sortField1;
  String _sortOrder1;
  String _sortField2;
  String _sortOrder2;
  String _sortField3;
  String _sortOrder3;
  String _showMain1;
  String _showMain2;
  String _showSec1;
  String _showSec2;
  String _showSec3;
  bool _filterIsDone;
  String _filterDateDue;
  String _filterCategory;

  CustomSettings(
      this._sortField1,
      this._sortOrder1,
      this._sortField2,
      this._sortOrder2,
      this._sortField3,
      this._sortOrder3,
      this._showMain1,
      this._showMain2,
      this._showSec1,
      this._showSec2,
      this._showSec3,
      this._filterIsDone,
      this._filterDateDue,
      this._filterCategory);
  CustomSettings.withId(
      this._id,
      this._sortField1,
      this._sortOrder1,
      this._sortField2,
      this._sortOrder2,
      this._sortField3,
      this._sortOrder3,
      this._showMain1,
      this._showMain2,
      this._showSec1,
      this._showSec2,
      this._showSec3,
      this._filterIsDone,
      this._filterDateDue,
      this._filterCategory);
  int get id => _id;
  String get sortField1 => _sortField1;
  String get sortOrder1 => _sortOrder1;
  String get sortField2 => _sortField2;
  String get sortOrder2 => _sortOrder2;
  String get sortField3 => _sortField3;
  String get sortOrder3 => _sortOrder3;
  String get showMain1 => _showMain1;
  String get showMain2 => _showMain2;
  String get showSec1 => _showSec1;
  String get showSec2 => _showSec2;
  String get showSec3 => _showSec3;
  bool get filterIsDone => _filterIsDone;
  String get filterDateDue => _filterDateDue;
  String get filterCategory => _filterCategory;

  set sortField1(String newSortField1) {
    this._sortField1 = newSortField1;
  }

  set sortOrder1(String newSortOrder1) {
    this._sortOrder1 = newSortOrder1;
  }

  set sortField2(String newSortField2) {
    this._sortField2 = newSortField2;
  }

  set sortOrder2(String newSortOrder2) {
    this._sortOrder2 = newSortOrder2;
  }

  set sortField3(String newSortField3) {
    this._sortField3 = newSortField3;
  }

  set sortOrder3(String newSortOrder3) {
    this._sortOrder3 = newSortOrder3;
  }

  set showMain1(String newShowMain1) {
    this._showMain1 = newShowMain1;
  }

  set showMain2(String newShowMain2) {
    this._showMain2 = newShowMain2;
  }

  set showSec1(String newShowSec1) {
    this._showSec1 = newShowSec1;
  }

  set showSec2(String newShowSec2) {
    this._showSec2 = newShowSec2;
  }

  set showSec3(String newShowSec3) {
    this._showSec3 = newShowSec3;
  }

  set filterIsDone(bool newFilterIsDone) {
    this._filterIsDone = newFilterIsDone;
  }

  set filterDateDue(String newFilterDateDue) {
    this._filterDateDue = newFilterDateDue;
  }

  set filterCategory(String newFilterCategory) {
    this._filterCategory = newFilterCategory;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['sortField1'] = _sortField1;
    map['sortOrder1'] = _sortOrder1;
    map['sortField2'] = _sortField2;
    map['sortOrder2'] = _sortOrder2;
    map['sortField3'] = _sortField3;
    map['sortOrder3'] = _sortOrder3;
    map['showMain1'] = _showMain1;
    map['showMain2'] = _showMain2;
    map['showSec1'] = _showSec1;
    map['showSec2'] = _showSec2;
    map['showSec3'] = _showSec3;
    map['filterIsDone'] = _filterIsDone;
    map['filterDateDue'] = _filterDateDue;
    map['filterCategory'] = _filterCategory;

    if (_id != null) {
      map['id'] = _id;
    }

    return map;
  }

  CustomSettings.fromObject(dynamic o) {
    this._id = o['id'];
    this._sortField1 = o['sortField1'];
    this._sortOrder1 = o['sortOrder1'];
    this._sortField2 = o['sortField2'];
    this._sortOrder2 = o['sortOrder2'];
    this._sortField3 = o['sortField3'];
    this._sortOrder3 = o['sortOrder3'];
    this._showMain1 = o['showMain1'];
    this._showMain2 = o['showMain2'];
    this._showSec1 = o['showSec1'];
    this._showSec2 = o['showSec2'];
    this._showSec3 = o['showSec3'];
    this._filterIsDone = o['filterIsDone'] == 0 ? false : true;
    this._filterDateDue = o['filterDateDue'];
    this._filterCategory = o['filterCategory'];
  }
}
