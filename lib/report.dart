import 'package:flutter/material.dart';
import "database/model/expenditure.dart";
import "dart:collection";
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ispent/database/database_helper.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ispent/utilities.dart';
import "package:collection/collection.dart";
var db = new DatabaseHelper();
List<charts.Series> seriesList = [];
final bool animate = false;
List<Expenditure> _categoryExpense = [];
var test;
Map<String, double> dataMap = Map();

class Report extends StatefulWidget {
  final int month;
  final int year;
  final int mode;

  Report(this.month,
      this.year,
      this.mode, {
        required Key key,
      }) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool toggle = false;
  Map<String, double> dataMap = new Map();
  int chartType = 0;
  late List<charts.Series<dynamic, DateTime>> seriesList;

  double getCategoryAmount(List<Expenditure> source, String categoryName) {
    double totalAmount = 0;
    for (int i = 0; i < source.length; i++) {
      if (source[i].itemName == categoryName) {
        totalAmount = totalAmount + source[i].amount;
      }
    }
    return totalAmount;
  }

  Future<List<Expenditure>> getExpenseList() {
    return db.getExpenses(widget.month, widget.year, widget.mode,0);
  }

  Future<List<Expenditure>> getYearExpense() {
    return db.getExpenses(widget.month, widget.year, 1,0);
  }

  @override
  void initState() {
    // Disable animations for image tests.
    super.initState();
    chartType = 0;
  }

  void prepareChartData(List<Expenditure> expenses) {
    _categoryExpense = []; //new List<Expenditure>();
    List<String> categoryList = []; //new List<String>();
    if (expenses.length > 0) {
      for (int i = 0; i < expenses.length; i++) {
        categoryList.add(expenses[i].itemName);
      }
      List<String> distinctCategory =
      LinkedHashSet<String>.from(categoryList).toList();
      for (var j = 0; j < distinctCategory.length; j++) {
        double totalAmount =
        getCategoryAmount(expenses, distinctCategory[j].toString());
        _categoryExpense.add(new Expenditure(
            totalAmount, distinctCategory[j].toString(), "", "", "",0));
        dataMap.putIfAbsent(distinctCategory[j].toString(), () => totalAmount);
      }
    }
  }

  void prepareBarChartData(List<Expenditure> expenses) {
    _categoryExpense = [];
    var groupByMonth =
    expenses.groupListsBy((obj) => obj.entryDate.substring(5, 7));
    groupByMonth.forEach((month, list) {

      double monthTotalExpense = 0.0;
      list.forEach((listItem) {
        // List item
        monthTotalExpense = monthTotalExpense + listItem.amount;

      });
      _categoryExpense.add(
          new Expenditure(
              monthTotalExpense, getMonthName(month), "", "", "",0));
    });
  }

  String getMonthName(String monNumber) {
    String returnValue = "Jan";
    switch (monNumber) {
      case "01":
        returnValue = "Jan";
        break;
      case "02":
        returnValue = "Feb";
        break;
      case "03":
        returnValue = "Mar";
        break;
      case "04":
        returnValue = "Apr";
        break;
      case "05":
        returnValue = "May";
        break;
      case "06":
        returnValue = "Jun";
        break;
      case "07":
        returnValue = "Jul";
        break;
      case "08":
        returnValue = "Aug";
        break;
      case "09":
        returnValue = "Sep";
        break;
      case "10":
        returnValue = "Oct";
        break;
      case "11":
        returnValue = "Nov";
        break;
      case "12":
        returnValue = "Dec";
        break;
    }
    return returnValue;
  }

  List<charts.Series<Expenditure, String>> getBarChartSeries(
      List<Expenditure> expenses) {
    prepareBarChartData(expenses);
    return _createBarChartData();
  }

  /// Create series list with single series
  List<charts.Series<Expenditure, String>> _createBarChartData() {
    return [
      new charts.Series<Expenditure, String>(
        id: 'Expense Summary',
        domainFn: (Expenditure sales, _) => sales.itemName,
        measureFn: (Expenditure sales, _) => sales.amount,
        data: _categoryExpense,
      ),
    ];
  }

  Map<String, double> getPieChartData(List<Expenditure> expenses) {
    dataMap = Map();
    _categoryExpense = []; //new List<Expenditure>();
    List<String> categoryList = []; //new List<String>();
    if (expenses.length > 0) {
      for (int i = 0; i < expenses.length; i++) {
        categoryList.add(expenses[i].itemName);
      }
      List<String> distinctCategory =
      LinkedHashSet<String>.from(categoryList).toList();
      for (var j = 0; j < distinctCategory.length; j++) {
        double totalAmount =
        getCategoryAmount(expenses, distinctCategory[j].toString());
        _categoryExpense.add(new Expenditure(
            totalAmount, distinctCategory[j].toString(), "", "", "",0));
        dataMap.putIfAbsent(distinctCategory[j].toString(), () => totalAmount);
      }
    }
    return dataMap;
  }

  @override
  Widget build(BuildContext context) {
    return _pieChart(context);
  }

  Widget _pieChart(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Scroll to right to see expense by month",
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.blueAccent,
                          ),
                        )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          // Another fixed-height child.
                            padding: EdgeInsets.only(left: 20, bottom: 40),
                            alignment: Alignment.topLeft,
                            child: new FutureBuilder<List<Expenditure>>(
                                future: getExpenseList(),
                                builder: (context, snapshot) {
                                 // if (snapshot.hasError)
                                  //  return Text("No Records Found");
                                  if (snapshot.hasData) {
                                    var data = snapshot.data;
                                    var dataSeries;
                                    if(data !=null){
                                       dataSeries = getPieChartData(data);
                                    }
                                    if (dataMap.isNotEmpty) {
                                      return new PieChart(
                                        dataMap: dataSeries,
                                        animationDuration:
                                        Duration(milliseconds: 1200),
                                        chartLegendSpacing: 32.0,
                                        chartRadius:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            1.5,
                                        chartValuesOptions: ChartValuesOptions(
                                          showChartValueBackground: true,
                                          showChartValues: true,
                                          showChartValuesInPercentage: true,
                                          showChartValuesOutside: true,
                                          decimalPlaces: 0,
                                        ),
                                        colorList: colorList,
                                        legendOptions: LegendOptions(
                                          showLegendsInRow: false,
                                          legendPosition: LegendPosition.right,
                                          showLegends: true,
                                          //legendShape: _BoxShape.circle,
                                          legendTextStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        chartType: ChartType.disc,
                                      );
                                    } else {
                                      return Center(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text("")));
                                    }
                                  } else {
                                    return Center(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text("")));
                                  }
                                })),
                        Container(child: _barChart(context)),
                        // Container(child: new SelectionCallbackExample(seriesList)),
                      ],
                    )
                  ])),
        );
      },
    );
  }

  Widget _barChart(BuildContext context) {
    return new FutureBuilder<List<Expenditure>>(
        future: getYearExpense(),
        builder: (context, snapshot) {
          if (snapshot.hasError) Text("");
          var data = snapshot.data;
          var barChartData;
          if(data != null) {
            barChartData = getBarChartSeries(data);
          }
          if (snapshot.hasData) {
            return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      //color: Colors.green, // Yellow
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.55,
                      width: getWidth(),
                      child: charts.BarChart(
                        barChartData,
                        behaviors: [
                          new charts.ChartTitle('Expense By Month',
                              behaviorPosition: charts.BehaviorPosition.top,
                              titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),

                        ],
                        animate: animate,
                        domainAxis: charts.OrdinalAxisSpec(
                          renderSpec:
                          charts.SmallTickRendererSpec(labelRotation: 0),
                        ),
                        defaultRenderer: new charts.BarRendererConfig(
                            groupingType: charts.BarGroupingType.stacked,
                            strokeWidthPx: 2.0),
                      ))
                ]));
          } else {
            return Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Text("")));
          }
        });

    /// Sample ordinal data type.
  }

  double getWidth() {
    int chartWidth = 0;
    chartWidth = (_categoryExpense.length * 35 + 80);
    return chartWidth.toDouble();
  }
}


