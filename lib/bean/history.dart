class SearchHistory {
  int _id;
  String _name;

  SearchHistory(this._name);

  SearchHistory.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
  }

  // ignore: unnecessary_getters_setters
  int get id => _id;
  // ignore: unnecessary_getters_setters
  set id(int value) => _id = value;

  // ignore: unnecessary_getters_setters
  String get name => _name;
  // ignore: unnecessary_getters_setters
  set name(String value) => _name = value;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    return map;
  }

  SearchHistory.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
  }
}
