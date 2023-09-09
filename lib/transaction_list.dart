import 'package:flutter/material.dart';
import "database/model/expenditure.dart";
import 'expense_delete.dart';
import 'screenarguments.dart';
import 'package:ispent/home_presenter.dart';
import 'package:intl/intl.dart';
import 'package:ispent/utilities.dart';
import 'package:ispent/database/database_helper.dart';
import 'package:toggle_switch/toggle_switch.dart';
var db = new DatabaseHelper();
int _swapIndex = 0;
class TransactionList extends StatefulWidget {
  final int mode;
  final int year;
  final int monthNumber;
  final String category;
  TransactionList(
    this.mode,
    this.year,
    this.monthNumber,this.category, {
    required Key key,
  }) : super(key: key);

  @override
  _TransactionListExpenseState createState() => _TransactionListExpenseState();
}

class _TransactionListExpenseState extends State<TransactionList>
    implements HomeContract {
  @override
  void initState() {
    // Disable animations for image tests.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Expenditure>>(
        future: getExpenseList(widget.monthNumber, widget.year, widget.mode),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Text("No Data Found")));
          }
          List<Expenditure>? _filteredExpenses = snapshot.data;
          if (snapshot.hasData) {

            return new Container(
                color: Colors.indigo[60],
                child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.indigo[50],
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: ToggleSwitch(
                            minWidth: 90.0,
                            initialLabelIndex: _swapIndex,
                            totalSwitches: 2,
                            labels: ['EXPENSE', 'INCOME'],
                            activeBgColors: [
                              [Colors.pink],
                              [Colors.green]
                            ],
                            inactiveBgColor: Colors.black26,
                            inactiveFgColor: Colors.black,
                            onToggle: (index) {
                              setState(() {
                                _swapIndex = index!;
                              });
                            },
                          )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(snapshot.data!.length.toString() + " item(s) found"),
                      )
                      ,
                      ConstrainedBox(
                          constraints: new BoxConstraints(
                            //minHeight: 300.0,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.63,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _filteredExpenses == null
                                ? 0
                                : _filteredExpenses.length,
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
                                                _filteredExpenses![index].icon),
                                            color: Colors.indigo,
                                          )),
                                          Expanded(
                                              flex: 2,
                                              child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Column(children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                              _filteredExpenses[
                                                                          index]
                                                                      .note
                                                                      .isEmpty
                                                                  ? _filteredExpenses[
                                                                          index]
                                                                      .itemName
                                                                  : _filteredExpenses[
                                                                          index]
                                                                      .note,
                                                            )),
                                                        Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                              DateFormat(
                                                                      'EEEE, d MMM, yyyy')
                                                                  .format(DateTime.parse(
                                                                      _filteredExpenses[
                                                                              index]
                                                                          .entryDate)),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .indigoAccent),
                                                            )),
                                                      ])))),
                                          Expanded(
                                            child: Text(
                                                _filteredExpenses[index]
                                                    .amount
                                                    .toStringAsFixed(2),
                                                textAlign: TextAlign.right,
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
                                                                  _filteredExpenses[
                                                                          index]
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
                                                                  .amount,_swapIndex), key: GlobalKey(),)),
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
                                              style: BorderStyle.solid))));
                            },
                          ))
                    ])));
          }
          return new Center(child: new CircularProgressIndicator());
        });
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}

Future<List<Expenditure>> getExpenseList(int monthNumber, int year, int mode) {
  return db.getExpenses(monthNumber, year, mode,_swapIndex);
}
