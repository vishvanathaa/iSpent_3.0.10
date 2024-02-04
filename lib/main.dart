import 'package:flutter/material.dart';
import 'package:ispent/home_presenter.dart';
import 'package:ispent/database/model/expenditure.dart';
import 'package:ispent/database/database_helper.dart';
import 'package:ispent/expenditure_list.dart';
import 'package:ispent/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ispent/appSettings.dart';
import 'package:ispent/transaction_list.dart';
import 'package:flutter/services.dart';
import 'package:ispent/report.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ispent/utilities.dart';
import 'package:toggle_switch/toggle_switch.dart';


double _totalExpense = 0;
double _totalIncome = 0;
double _budget = 0;
int _mode = 0;
int _year = DateTime.now().year;
int _monthNumber = DateTime.now().month;
List<Expenditure> _expenditureList = List.empty();
bool visible = true;
int _swapIndex = 0;
var db = new DatabaseHelper();
DateTime _currentDateTime = DateTime.now();

class ISpentContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          'first': (BuildContext context) => new ISpentHome(key: GlobalKey(), title: '',),
          '/second': (BuildContext context) => new ExpenseScreen(data:0, key: GlobalKey(),),
          '/expense': (BuildContext context) => new ExpenseScreen(data:0, key: GlobalKey(),),
        },
        home: ISpentHome(key: GlobalKey(), title: '',));
  }
}

class ISpentHome extends StatefulWidget {
  ISpentHome({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<ISpentHome> implements HomeContract {
  @override
  void screenUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    getSettings();
    _currentDateTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetKey = 'budget_double_key';
    final modeKey = 'mode_int_key';
    final mode = prefs.getInt(modeKey) ?? 0;
    final budget = prefs.getInt(budgetKey) ?? 0.00;
    setState(() {
      _budget = budget.toDouble();
      _monthNumber = DateTime.now().month;
      _year = DateTime.now().year;
      _mode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentMonth = getMonthName(_monthNumber);
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        drawer: Drawer(

          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.

          child: ListView(
            children: [
              _tile('CONTRIBUTORS', '',  Icons.call_received),
              _tile('Vishvanatha Acharya', 'Amasebail, Udupi', Icons.person),
              _tile('Shubharathna', 'Mandarthi, Udupi', Icons.person),
              _tile('Shivakumar', 'Elevation Media, Bangalore', Icons.person),
              _tile('Naveena Bhandari', 'Shimoga', Icons.person),
              _tile('Ravindar Ganji', 'Greater Hyderabad Telengana', Icons.person),
              _tile('Dr. Jagadeesh Krishna', 'Mysore', Icons.person),
              _tile('Binoy P J', 'Kerala', Icons.person),
              _tile('Naveen Desouza', 'Bramhavar, Udupi', Icons.person),

              Padding(
                padding: const EdgeInsets.only(left: 10, top: 0, right: 10),
                child:
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.info_outline,
                            color: Colors.red),
                      ),
                      TextSpan(
                        text: " This app does not require an internet connection or mobile data to function. Your data is securely stored in your mobile device's memory, and no unauthorized access is possible.",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              )

            ],
          ),
        ),
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: false,
          //titleSpacing: -5,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.1,
          backgroundColor: Colors.indigo,
          title: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_left,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_mode == 0) {
                        var newDate = Jiffy(_currentDateTime)
                            .subtract(months: 1)
                            .dateTime;
                        _monthNumber = newDate.month;
                        _currentDateTime = newDate;
                        _year = newDate.year;
                      } else {
                        _year -= 1;
                      }
                    });
                    // do what you need to do when "Click here" gets clicked
                  }),
              Text(
                (_mode == 0 ? currentMonth : "Year") + " - " + _year.toString(),
                style: TextStyle(fontSize: 25,color: Colors.white),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  setState(() {
                    if (_mode == 0) {
                      var newDate =
                          Jiffy(_currentDateTime).add(months: 1).dateTime;
                      _monthNumber = newDate.month;
                      _currentDateTime = newDate;
                      _year = newDate.year;
                    } else {
                      _year += 1;
                    }
                  });
                },
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(letterSpacing: 0.1),
            tabs: choices.map((Choice choice) {
              return Tab(
                text: choice.title,
                icon: Icon(choice.icon),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: choices.map((Choice choice) {
            return Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                // height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: ChoiceCard(choice: choice, key: GlobalKey(),)),

            );
          }).toList(),
        ),

      ),
    );
  }
}

class ChoiceCard extends StatefulWidget {
  final Choice choice;

  const ChoiceCard({required Key key, required this.choice}) : super(key: key);

  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  @override
  Widget build(BuildContext context) {
    var choiceType = widget.choice.title.toUpperCase();
    if (choiceType == "DASHBOARD") {
      return new Container(
          color: Colors.grey.shade800,
          child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.grey.shade800,
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: ToggleSwitch(
                      minWidth: 85.0,
                      initialLabelIndex: _swapIndex,
                      totalSwitches: 2,
                      labels: ['EXPENSE', 'INCOME'],
                      activeBgColors: [
                        [Colors.pink],
                        [Colors.green]
                      ],
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.black,
                      onToggle: (index) {
                        setState(() {
                          _swapIndex = index!;
                        });
                      },
                    )),
                _headerBudgetView(context),
                Divider(
                    color: Colors.white38
                ),
                _expenseListView(context),
                _addIncomeButton(context)

              ])));
    } else if (choiceType == "SETTINGS") {
      return AppSettings();
    } else if (choiceType == "REPORT") {
      return new Report(_monthNumber, _year, _mode, key: GlobalKey(),);
    } else {
      return new TransactionList(_mode, _year, _monthNumber, "", key: GlobalKey(),);
    }
  }
}
Widget _addExpenseButton(BuildContext context){
  return FloatingActionButton.extended(
    onPressed: () {
      // Add your onPressed code here!
      /*Navigator.pushNamed(context, '/second');*/
      Navigator.of(context).push(
        // With MaterialPageRoute, you can pass data between pages,
        // but if you have a more complex app, you will quickly get lost.
        MaterialPageRoute(
          builder: (context) =>
              ExpenseScreen(data: 0, key: GlobalKey(),),
        ),
      );
    },
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(35.0))
    ),
    icon: Icon(Icons.add,color: Colors.white,),
    label: Text(
      "ADD EXPENSE",
      style: TextStyle(
          letterSpacing: 0.3,
          wordSpacing: 0.3,
          color:Colors.white
      ),
    ),
    backgroundColor: Colors.pink,
  );
}
Widget _addIncomeButton(BuildContext context)
{

  if(_swapIndex == 1) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),

        ),

      ),

      icon: const Icon(Icons.add, color: Colors.white),
      //`Icon` to display
      label: Text(
        'ADD INCOME',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).push(
          // With MaterialPageRoute, you can pass data between pages,
          // but if you have a more complex app, you will quickly get lost.
          MaterialPageRoute(
            builder: (context) =>
                ExpenseScreen(data: 1, key: GlobalKey(),),
          ),
        );
      },
    );
  }else if(_swapIndex == 0){
    return _addExpenseButton(context);

  }else{
    return SizedBox(height: 0.01);
  }
}

Widget _headerBudgetView(BuildContext context) {
  if(_swapIndex == 0) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 3.0, top: 5.0),
            child: Text(
              'BUDGET',
              style: new TextStyle(
                //fontFamily: "Quicksand",
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 35.0, bottom: 3.0, top: 5.0),
            child: Text(
              _budget.toStringAsFixed(2),
              style: new TextStyle(
                fontFamily: "Quicksand",
                fontSize: 16.0,
                color: Colors.lightGreen,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),
        )
      ],
    );
  }
  else{
    return SizedBox(height: 0.5);
  }
}

Widget _balanceView(BuildContext context) {
  if(_swapIndex == 0) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 5.0, top: 2.0),
            child: Text(
              "BALANCE",
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 35.0, bottom: 5.0, top: 3.0),
            child: Text(
              (_totalIncome - _totalExpense).toStringAsFixed(2),
              style: new TextStyle(
                //fontFamily: "Quicksand",
                fontSize: 16.0,
                color: (_totalIncome - _totalExpense) > 0 ?Colors.green : Colors.red,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
  else{
    return SizedBox(height:0.5);
  }
}

Widget _headerExpenseView(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 12.0, bottom: 5.0, top: 15),
          child: Text(
            _swapIndex ==0?"TOTAL EXPENSE":"TOTAL INCOME",
            style: new TextStyle(
              //fontFamily: "Quicksand",
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,

            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 35.0),
          child: Text(
            _totalExpense.toStringAsFixed(2),
            style: new TextStyle(
              //fontFamily: "Quicksand",
              fontSize: 16.0,
              color: _swapIndex==0?Colors.orange:Colors.greenAccent,
              fontWeight: FontWeight.bold,

            ),
          ),
        ),
      )
    ],
  );
}

Future<List<Expenditure>> getExpenseList(int type) {
  return db.getExpenses(_monthNumber, _year, _mode,type);
}

double getTotalExpense(List<Expenditure> expenses) {
  double totalExpense = 0.0;
  for (var expense in expenses) {
    totalExpense = totalExpense + expense.amount;
  }
  return totalExpense;
}
Widget GetTotalIncome()
{
  return FutureBuilder<List<Expenditure>>(
      future: getExpenseList(1),
      builder: (context, snapshot) {
        if (snapshot.hasError) {return Divider(
            color: Colors.blueGrey
        );}
        var data = snapshot.data;
        if(data != null) {
          _expenditureList = data;

        }
        if (snapshot.hasData) {
          _totalIncome = getTotalExpense(_expenditureList);
         return _balanceView(context);
        }
        return Divider(
            color: Colors.white38
        );
      });

}
Widget _expenseListView(BuildContext context) {
  return FutureBuilder<List<Expenditure>>(
      future: getExpenseList(_swapIndex),
      builder: (context, snapshot) {
        if (snapshot.hasError) {return Center(
            child: Align(
                alignment: Alignment.center,
                child: Text("No Data Found",style: TextStyle(color: Colors.white))));}
        var data = snapshot.data;
        if(data != null) {
          _expenditureList = data;
        }
        if (snapshot.hasData) {
          _totalExpense = getTotalExpense(_expenditureList);

          return new Column(children: [
            ExpenditureList(_expenditureList, _mode, _year, _monthNumber,_swapIndex, key: GlobalKey(),),

            _headerExpenseView(context),
            Divider(
            color: Colors.white38
        ),
            GetTotalIncome(),
          ]);
        }
        return new Center(child: new CircularProgressIndicator());
      });
}

ListTile _tile(String title, String subtitle, IconData icon) {
  return ListTile(
    dense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal:
    5.0),
    title: Text(
      title,
    ),
    subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
  );
}

void main() {
  runApp(ISpentContainer());
}
