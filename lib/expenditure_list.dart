import 'package:flutter/material.dart';
import 'package:ispent/category_expense.dart';
import 'database/model/expenditure.dart';
import 'package:ispent/utilities.dart';

class ExpenditureList extends StatelessWidget {
  final List<Expenditure> expenses;
  final int mode;
  final int year;
  final int monthNumber;
  final int type;
  ExpenditureList(
    this.expenses,
    this.mode,
    this.year,
    this.monthNumber,this.type, {
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expenseList = getConsolidatedList(expenses);
    return ConstrainedBox(
        constraints: new BoxConstraints(
          //minHeight: 300.0,
          maxHeight: MediaQuery.of(context).size.height * 0.45,
        ),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: expenseList.length,
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.only(left: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Padding(
                        padding: EdgeInsets.only(left: 2.0, right: 0.0),
                        child:  IconButton(
                                icon: new Icon(
                                  getIconName(expenseList[index].icon),
                                  color: Colors.greenAccent,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryExpense(
                                            mode,
                                            year,
                                            monthNumber,
                                            expenseList[index].itemName,type, key: GlobalKey(),)),
                                  );
                                })),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          //data[index].itemName,
                          expenseList[index].itemName +" (" + expenseList[index].note + ")",
                          style: new TextStyle(
                            // fontFamily: "Quicksand",
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 35.0),
                        child: Text(
                          expenseList[index].amount.toStringAsFixed(2),
                          style: new TextStyle(
                            //fontFamily: "Quicksand",
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                decoration: new BoxDecoration(
                    border: new Border(
                        bottom: new BorderSide(
                  color: Colors.grey.shade700,
                ))));
          },
        ));
  }
}

List<Expenditure> getConsolidatedList(List<Expenditure> expenses) {
  List<Expenditure> _categoryExpense = []; //new List<Expenditure>();
  var seen = Set<String>();
  List<Expenditure> distinctCategory =
      expenses.where((i) => seen.add(i.itemName)).toList();
  for (var j = 0; j < distinctCategory.length; j++) {
    double totalAmount =
        getCategoryAmount(expenses, distinctCategory[j].itemName);
    int categoryCount =
        getCategoryCount(expenses, distinctCategory[j].itemName);
    _categoryExpense.add(new Expenditure(
        totalAmount,
        distinctCategory[j].itemName,
        "",
        distinctCategory[j].icon,
        categoryCount.toString(),0));
  }
  return _categoryExpense;
}

double getCategoryAmount(List<Expenditure> source, String categoryName) {
  double totalAmount = 0;
  for (int i = 0; i < source.length; i++) {
    if (source[i].itemName == categoryName) {
      totalAmount = totalAmount + source[i].amount;
    }
  }
  return totalAmount;
}

int getCategoryCount(List<Expenditure> source, String categoryName) {
  int totalCount = 0;
  for (int i = 0; i < source.length; i++) {
    if (source[i].itemName == categoryName) {
      totalCount = totalCount + 1;
    }
  }
  return totalCount;
}
