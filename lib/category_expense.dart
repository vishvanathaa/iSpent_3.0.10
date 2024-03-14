import 'package:flutter/material.dart';
import "database/model/expenditure.dart";
import 'expense_delete.dart';
import 'screenarguments.dart';
import 'package:ispent/home_presenter.dart';
import 'package:intl/intl.dart';
import 'package:ispent/utilities.dart';
import 'package:ispent/database/database_helper.dart';

var db = new DatabaseHelper();

class CategoryExpense extends StatefulWidget {
  final int mode;
  final int year;
  final int monthNumber;
  final String category;
  final int type;
  CategoryExpense(
    this.mode,
    this.year,
    this.monthNumber,
    this.category,this.type, {
    required Key key,
  }) : super(key: key);

  @override
  _CategoryExpenseState createState() => _CategoryExpenseState();
}

class _CategoryExpenseState extends State<CategoryExpense>
    implements HomeContract {
  @override
  void initState() {
    // Disable animations for image tests.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category,style:TextStyle(color: Colors.white)),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        //resizeToAvoidBottomPadding: false,
        body: Column(children: [
          new FutureBuilder<List<Expenditure>>(
              future:
                  getExpenseList(widget.monthNumber, widget.year, widget.mode,widget.type),
              builder: (context, snapshot) {
                if (snapshot.hasError) Text("");
                List<Expenditure> _filteredExpenses =
                    getFilteredExpense(snapshot.data!, widget.category);
                if (snapshot.hasData) {
                  return new Container(
                      color: Colors.indigo[60],
                      child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.indigo[50],
                          child: Column(children: [
                            Text(_filteredExpenses.length.toString() + " item(s) found"),
                            ConstrainedBox(
                                constraints: new BoxConstraints(
                                  //minHeight: 300.0,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.63,
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _filteredExpenses.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 3),
                                            child: Row(
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: Icon(
                                                  getIconName(
                                                      _filteredExpenses[index]
                                                          .icon),
                                                  color: widget.type==0?Colors.red:Colors.green,
                                                )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 0),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Column(
                                                                children: [
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child:
                                                                          Text(
                                                                        _filteredExpenses[index].note.isEmpty
                                                                            ? _filteredExpenses[index].itemName
                                                                            : _filteredExpenses[index].note,
                                                                      )),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child:
                                                                          Text(
                                                                        DateFormat('EEEE, d MMM, yyyy')
                                                                            .format(DateTime.parse(_filteredExpenses[index].entryDate)),
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.indigoAccent),
                                                                      )),
                                                                ])))),
                                                Expanded(
                                                  child: Text(
                                                      _filteredExpenses[index]
                                                          .amount
                                                          .toStringAsFixed(2),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                                Expanded(
                                                  child: IconButton(
                                                    tooltip: "Click to edit",
                                                    icon: Icon(Icons.edit,
                                                        color: Colors.indigo),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => DeleteExpenseScreen(
                                                                args: new ScreenArguments(
                                                                    _filteredExpenses[
                                                                            index]
                                                                        .itemName,
                                                                    getIconName(
                                                                        _filteredExpenses[index]
                                                                            .icon),
                                                                    _filteredExpenses[
                                                                            index]
                                                                        .itemName,
                                                                    _filteredExpenses[
                                                                            index]
                                                                        .icon,
                                                                    _filteredExpenses[
                                                                            index]
                                                                        .entryDate,
                                                                    _filteredExpenses[
                                                                            index]
                                                                        .note,
                                                                    _filteredExpenses[
                                                                            index]
                                                                        .id,
                                                                    _filteredExpenses[
                                                                            index]
                                                                        .amount,widget.type), key: GlobalKey(),)),
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            )),
                                        decoration: new BoxDecoration(
                                            color: Colors.indigo[50],
                                            border: new Border(
                                                bottom: new BorderSide(
                                                    color: Colors.indigo.shade100,
                                                    style:
                                                        BorderStyle.solid))));
                                  },
                                ))
                          ])));
                }
                return new Center(child: new CircularProgressIndicator());
              })
        ]));
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}

List<Expenditure> getFilteredExpense(
    List<Expenditure> expenseList, String categoryName) {
  return expenseList.where((i) => i.itemName == categoryName).toList();
}

Future<List<Expenditure>> getExpenseList(int monthNumber, int year, int mode,int type) {
  return db.getExpenses(monthNumber, year, mode,type);
}
