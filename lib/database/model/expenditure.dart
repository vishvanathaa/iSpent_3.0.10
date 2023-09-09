class Expenditure {

  int id = 0;
  double _amount = 0.0;
  String _itemName = "";
  String _entryDate="";
  String _icon = "";
  String _note = "";
  int _type =0;

  Expenditure(this._amount, this._itemName, this._entryDate,this._icon,this._note,this._type);

  Expenditure.map(dynamic obj) {
    this._amount = obj["amount"];
    this._itemName = obj["itemname"];
    this._entryDate = obj["entrydate"];
    this._note = obj["note"];
    this._icon = obj["icon"];
    this._type = obj["categorytype"];
  }

  double get amount => _amount;
  String get itemName => _itemName;
  String get icon => _icon;
  String get entryDate => _entryDate;
  String get note => _note;
  int get categorytype => _type;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["amount"] = _amount;
    map["itemname"] = _itemName;
    map["entrydate"] = _entryDate;
    map["icon"] = _icon;
    map["note"] = _note;
    map["categorytype"] = _type;

    return map;
  }

  void setExpenditureId(int id) {
    this.id = id;
  }
}