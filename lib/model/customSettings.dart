class CustomSettings {
  int? _id;
  String? _sortField1;
  String? _sortOrder1;
  String? _sortField2;
  String? _sortOrder2;
  String? _sortField3;
  String? _sortOrder3;
  String? _sortField4;
  String? _sortOrder4;
  String? _showSec1;
  String? _showSec2;
  String? _showSec3;
  String? _filterDateDue;
  String? _filterCategory;
  String? _filterStatus;
  String? _filterPriority;
  String? _filterTag;
  int? _filterIsStar;
  int? _filterIsDone;

  CustomSettings(
    this._sortField1,
    this._sortOrder1,
    this._sortField2,
    this._sortOrder2,
    this._sortField3,
    this._sortOrder3,
    this._sortField4,
    this._sortOrder4,
    this._showSec1,
    this._showSec2,
    this._showSec3,
    this._filterDateDue,
    this._filterCategory,
    this._filterStatus,
    this._filterPriority,
    this._filterTag,
    this._filterIsStar,
    this._filterIsDone,
  );
  CustomSettings.withId(
    this._id,
    this._sortField1,
    this._sortOrder1,
    this._sortField2,
    this._sortOrder2,
    this._sortField3,
    this._sortOrder3,
    this._sortField4,
    this._sortOrder4,
    this._showSec1,
    this._showSec2,
    this._showSec3,
    this._filterDateDue,
    this._filterCategory,
    this._filterStatus,
    this._filterPriority,
    this._filterTag,
    this._filterIsStar,
    this._filterIsDone,
  );
  int? get id => _id;
  String? get sortField1 => _sortField1;
  String? get sortOrder1 => _sortOrder1;
  String? get sortField2 => _sortField2;
  String? get sortOrder2 => _sortOrder2;
  String? get sortField3 => _sortField3;
  String? get sortOrder3 => _sortOrder3;
  String? get sortField4 => _sortField4;
  String? get sortOrder4 => _sortOrder4;
  String? get showSec1 => _showSec1;
  String? get showSec2 => _showSec2;
  String? get showSec3 => _showSec3;
  String? get filterDateDue => _filterDateDue;
  String? get filterCategory => _filterCategory;
  String? get filterStatus => _filterStatus;
  String? get filterPriority => _filterPriority;
  String? get filterTag => _filterTag;
  int? get filterIsStar => _filterIsStar;
  int? get filterIsDone => _filterIsDone;

  set sortField1(String? newSortField1) {
    this._sortField1 = newSortField1;
  }

  set sortOrder1(String? newSortOrder1) {
    this._sortOrder1 = newSortOrder1;
  }

  set sortField2(String? newSortField2) {
    this._sortField2 = newSortField2;
  }

  set sortOrder2(String? newSortOrder2) {
    this._sortOrder2 = newSortOrder2;
  }

  set sortField3(String? newSortField3) {
    this._sortField3 = newSortField3;
  }

  set sortOrder3(String? newSortOrder3) {
    this._sortOrder3 = newSortOrder3;
  }

  set sortField4(String? newSortField4) {
    this._sortField4 = newSortField4;
  }

  set sortOrder4(String? newSortOrder4) {
    this._sortOrder4 = newSortOrder4;
  }

  set showSec1(String? newShowSec1) {
    this._showSec1 = newShowSec1;
  }

  set showSec2(String? newShowSec2) {
    this._showSec2 = newShowSec2;
  }

  set showSec3(String? newShowSec3) {
    this._showSec3 = newShowSec3;
  }

  set filterDateDue(String? newFilterDateDue) {
    this._filterDateDue = newFilterDateDue;
  }

  set filterCategory(String? newFilterCategory) {
    this._filterCategory = newFilterCategory;
  }

  set filterStatus(String? newFilterStatus) {
    this._filterStatus = newFilterStatus;
  }

  set filterPriority(String? newFilterPriority) {
    this._filterPriority = newFilterPriority;
  }

  set filterTag(String? newFilterTag) {
    this._filterTag = newFilterTag;
  }

  set filterIsStar(int? newFilterIsStar) {
    this._filterIsStar = newFilterIsStar;
  }

  set filterIsDone(int? newFilterIsDone) {
    this._filterIsDone = newFilterIsDone;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['sortField1'] = _sortField1;
    map['sortOrder1'] = _sortOrder1;
    map['sortField2'] = _sortField2;
    map['sortOrder2'] = _sortOrder2;
    map['sortField3'] = _sortField3;
    map['sortOrder3'] = _sortOrder3;
    map['sortField4'] = _sortField4;
    map['sortOrder4'] = _sortOrder4;
    map['showSec1'] = _showSec1;
    map['showSec2'] = _showSec2;
    map['showSec3'] = _showSec3;
    map['filterDateDue'] = _filterDateDue;
    map['filterCategory'] = _filterCategory;
    map['filterStatus'] = _filterStatus;
    map['filterPriority'] = _filterPriority;
    map['filterTag'] = _filterTag;
    map['filterIsStar'] = _filterIsStar;
    map['filterIsDone'] = _filterIsDone;

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
    this._sortField4 = o['sortField4'];
    this._sortOrder4 = o['sortOrder4'];
    this._showSec1 = o['showSec1'];
    this._showSec2 = o['showSec2'];
    this._showSec3 = o['showSec3'];
    this._filterDateDue = o['filterDateDue'];
    this._filterCategory = o['filterCategory'];
    this._filterStatus = o['filterStatus'];
    this._filterPriority = o['filterPriority'];
    this._filterTag = o['filterTag'];
    this._filterIsStar = o['filterIsStar']; 
    this._filterIsDone = o['filterIsDone'];
  }
}