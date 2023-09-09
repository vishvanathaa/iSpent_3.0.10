import 'dart:async';
import 'dart:io' as io;
import 'package:ispent/database/model/expenditure.dart';
import 'package:ispent/database/model/category.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  //static Database _db = "" as Database;
  static dynamic _db;
  Future<Database> get db async {
    if (_db != "" && _db!= null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "vishwakarma.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Expenditure(id INTEGER PRIMARY KEY, amount REAL, itemname TEXT, entrydate TEXT,icon TEXT,note TEXT)");

    await db.execute("ALTER TABLE Expenditure ADD COLUMN categorytype INTEGER DEFAULT 0");
    await db.execute(
        "CREATE TABLE Category(id INTEGER PRIMARY KEY, categoryname TEXT)");
    await db.execute("ALTER TABLE Category ADD COLUMN categorytype INTEGER DEFAULT 0");
  }

  Future<int> saveUser(Expenditure expenditure) async {

    var dbClient = await db;
    int res = await dbClient.insert("Expenditure", expenditure.toMap());

    return res;
  }
  Future<int> addCategory(Category category) async {
    var dbClient = await db;
    int res = await dbClient.insert("Category", category.toMap());
    return res;
  }
  Future<int?> getCategoryCount() async {
    //database connection
    var dbClient = await db;
    var x = await dbClient.rawQuery('SELECT COUNT(1) Category');
        int? count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<List<Category>> getCategories(int swapIndex) async {
    var dbClient = await db;
    var query = "SELECT * FROM Category WHERE categorytype = "+swapIndex.toString()+" ORDER BY id DESC";
    List<Map> list = await dbClient.rawQuery(query);
    List<Category> categories = [];
    for (int i = 0; i < list.length; i++) {
      var category = new Category(list[i]["categoryname"],list[i]["categorytype"]);
      category.setCategoryId(list[i]["id"]);
      categories.add(category);
    }
    return categories;
  }

  Future<List<Expenditure>> getExpenses(int month, int year, int mode,int type) async {

    var dbClient = await db;
    var query;
    if (mode == 0) {
      query = "SELECT * FROM Expenditure WHERE CAST(strftime('%m', strftime('%s',date(entrydate)), 'unixepoch') AS INTEGER)  = " +
          month.toString() +
          " AND  CAST(strftime('%Y', strftime('%s',date(entrydate)), 'unixepoch') AS INTEGER)  = " +
          year.toString() +
          " AND categorytype = "+type.toString()+"";
    } else {
      query =
          "SELECT * FROM Expenditure WHERE CAST(strftime('%Y', strftime('%s',date(entrydate)), 'unixepoch') AS INTEGER)  = " +
              year.toString() +
              " AND categorytype = "+type.toString()+"";
    }
    List<Map> list = await dbClient.rawQuery(query);
    List<Expenditure> expenses = [];
    for (int i = 0; i < list.length; i++) {
      var user = new Expenditure(list[i]["amount"], list[i]["itemname"],
          list[i]["entrydate"], list[i]["icon"], list[i]["note"],list[i]["categorytype"]);
      user.setExpenditureId(list[i]["id"]);
      expenses.add(user);
    }
    return expenses;
  }

  Future<int> deleteUsers(Expenditure expense) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM Expenditure WHERE id = ?', [expense.id]);
    return res;
  }

  Future<bool> update(Expenditure expense) async {
    var dbClient = await db;
    int res = await dbClient.update("Expenditure", expense.toMap(),
        where: "id = ?", whereArgs: <int>[expense.id]);
    return res > 0 ? true : false;
  }
}
