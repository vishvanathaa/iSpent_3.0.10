class Category {
  int id = 0;
  String _category = "";
  int _categoryType = 0;

  Category(this._category,this._categoryType);

  Category.map(dynamic obj) {
    this._category = obj["categoryname"];
    this._categoryType = obj["categorytype"];
  }

  String get categoryName => _category;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["categoryname"] = _category;
    map["categorytype"] = _categoryType;
    return map;
  }

  void setCategoryId(int id) {
    this.id = id;
  }
}