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
  String _filterAction;
  String _filterContext;
  String _filterLocation;
  String _filterTag;
  String _filterStatus;
  String _filterPriority;
  String _filterGoal;
  String _filterStar;

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
      this._filterCategory,
      this._filterAction,
      this._filterContext,
      this._filterLocation,
      this._filterTag,
      this._filterStatus,
      this._filterPriority,
      this._filterGoal,
      this._filterStar);
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
      this._filterCategory,
      this._filterAction,
      this._filterContext,
      this._filterLocation,
      this._filterTag,
      this._filterStatus,
      this._filterPriority,
      this._filterGoal,
      this._filterStar);
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
  String get filterAction => _filterAction;
  String get filterContext => _filterContext;
  String get filterLocation => _filterLocation;
  String get filterTag => _filterTag;
  String get filterStatus => _filterStatus;
  String get filterPriority => _filterPriority;
  String get filterGoal => _filterGoal;
  String get filterStar => _filterStar; 

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

  set filterAction(String newFilterAction) {
    this._filterAction = newFilterAction;
  }

  set filterContext(String newFilterContext) {
    this._filterContext = newFilterContext;
  }

  set filterLocation(String newFilterLocation) {
    this._filterLocation = newFilterLocation;
  }

  set filterTag(String newFilterTag) {
    this._filterTag = newFilterTag;
  }

  set filterStatus(String newFilterStatus) {
    this._filterStatus = newFilterStatus;
  }

  set filterPriority(String newFilterPriority) {
    this._filterPriority = newFilterPriority;
  }

  set filterGoal(String newFilterGoal) {
    this._filterGoal = newFilterGoal;
  }

  set filterStar(String newFilterStar) {
    this._filterStar = newFilterStar;
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
    map['filterAction'] = _filterAction;
    map['filterContext'] = _filterContext;
    map['filterLocation'] = _filterLocation;
    map['filterTag'] = _filterTag;
    map['filterStatus'] = _filterStatus;
    map['filterPriority'] = _filterPriority;
    map['filterGoal'] = _filterGoal;
    map['filterStar'] = _filterStar;

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
    this._filterAction = o['filterAction'];
    this._filterContext = o['filterContext'];
    this._filterLocation = o['filterLocation'];
    this._filterTag = o['filterTag'];
    this._filterStatus = o['filterstatus'];
    this._filterPriority = o['filterPriority'];
    this._filterGoal = o['filterGoal'];
    this._filterStar = o['filterStar'];
  }
}
