class SearchHistory {
  SearchHistory();
  int _id;
  String _name;

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
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

  SearchHistory.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
  }
}
