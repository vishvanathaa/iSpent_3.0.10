import 'package:flutter/material.dart';
import 'package:ispent/addExpense.dart';
import 'package:ispent/addExpenseCategory.dart';
import 'package:ispent/screenarguments.dart';
import 'package:ispent/database/model/category.dart';
import 'package:ispent/database/database_helper.dart';

class ExpenseScreen extends StatefulWidget {
  final int data;

  ExpenseScreen({
    required Key key,
    required this.data,
  }) : super(key: key);

  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(widget.data == 0 ?"Expense Categories":"Income Categories"),
        backgroundColor: Colors.indigo,
      ),
      //resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          expenseCategoryList(context),
          Expanded(child:
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.71,
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                widget.data==0?
                SliverPadding(
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 4,
                    children: <Widget>[
                      getCategory(Icons.local_grocery_store, "Grocery",
                          "local_grocery_store",widget.data),
                      getCategory(Icons.add_shopping_cart, "Shopping",
                          "add_shopping_cart",widget.data),
                      getCategory(Icons.business, "Business", "business",widget.data),
                      getCategory(Icons.local_offer, "Meat", "local_offer",widget.data),
                      getCategory(
                          Icons.smoking_rooms, "Smoking", "smoking_rooms",widget.data),
                      getCategory(
                          Icons.local_dining, "Eatables", "local_dining",widget.data),
                      getCategory(Icons.local_drink, "Drinks", "local_drink",widget.data),
                      getCategory(Icons.theaters, "Fun", "theaters",widget.data),
                      getCategory(Icons.loyalty, "Bills", "loyalty",widget.data),
                      getCategory(Icons.spa, "Fashion", "spa",widget.data),
                      getCategory(Icons.airplanemode_active, "Travel",
                          "airplanemode_active",widget.data),
                      getCategory(
                          Icons.local_gas_station, "Fuel", "local_gas_station",widget.data),
                      getCategory(
                          Icons.shopping_basket, "Veg", "shopping_basket",widget.data),
                      getCategory(Icons.home, "Household", "home",widget.data),
                      getCategory(
                          Icons.local_movies, "Function", "local_movies",widget.data),
                      getCategory(Icons.book, "Stationary", "book",widget.data),
                      getCategory(Icons.phone_iphone, "Phone", "phone_iphone",widget.data),
                      getCategory(Icons.toys, "Toys", "toys",widget.data),
                      getCategory(
                          Icons.local_hospital, "Health", "local_hospital",widget.data),
                      getCategory(Icons.security, "Insurance", "security",widget.data),
                      getCategory(Icons.school, "Education", "school",widget.data),
                      getCategory(Icons.pets, "Pets", "pets",widget.data),
                      getCategory(Icons.security, "Security", "Security",widget.data),
                      getCategory(Icons.alarm, "EMI", "alarm",widget.data),
                      getCategory(
                          Icons.location_city, "Creation", "location_city",widget.data),
                      getCategory(Icons.computer, "Computer", "computer",widget.data),
                      getCategory(Icons.bug_report, "Repair", "bug_report",widget.data),
                      getCategory(Icons.games, "Sports", "games",widget.data),
                      getCategory(
                          Icons.directions_car, "Car", "directions_car",widget.data),
                      getCategory(Icons.train, "Train", "train",widget.data),
                      getCategory(Icons.local_taxi, "Taxi", "local_taxi",widget.data),
                      getCategory(
                          Icons.directions_bike, "Bike", "directions_bike",widget.data),
                      getCategory(
                          Icons.directions_bus, "Bus", "directions_bus",widget.data),
                      getCategory(
                          Icons.monetization_on, "Rent", "monetization_on",widget.data),
                      getCategory(Icons.star_border, "Others", "star_border",widget.data),
                      addCategory(
                          Icons.local_hospital, "Add New", "local_hospital",0)
                      ,
                    ],
                  ),
                ): SliverPadding(
    padding: const EdgeInsets.only(left: 10, right: 15),
    sliver: SliverGrid.count(
    crossAxisSpacing: 2,
    mainAxisSpacing: 2,
    crossAxisCount: 4,
    children: <Widget>[
    getCategory(Icons.account_balance_wallet, "Salary",
    "account_balance_wallet",widget.data),
    getCategory(Icons.business, "Business", "business",widget.data),
    getCategory(Icons.theaters, "Ads", "theaters",widget.data),
      getCategory(Icons.grass, "grants", "grass",widget.data),
    getCategory(Icons.loyalty, "Sale", "loyalty",widget.data),
      getCategory(
          Icons.location_city, "Estate", "location_city",widget.data),
      getCategory(Icons.bar_chart, "Dividend", "bar_chart",widget.data),
      getCategory(Icons.spa, "Lottery", "spa",widget.data),
      getCategory(
          Icons.monetization_on, "Bond", "monetization_on",widget.data),
      getCategory(Icons.bug_report, "Services", "bug_report",widget.data),
      getCategory(Icons.school, "Education", "school",widget.data),
      getCategory(Icons.pie_chart, "Shares", "pie_chart",widget.data),
      getCategory(Icons.home, "Rental", "home",widget.data),
      getCategory(Icons.security, "Deposit", "security",widget.data),
      getCategory(
          Icons.monetization_on, "Pension", "monetization_on",widget.data),
    getCategory(
    Icons.celebration_outlined, "Coupons", "celebration_outlined",widget.data),
    getCategory(Icons.alarm, "Refunds", "alarm",widget.data),
      getCategory(Icons.account_balance_wallet_outlined, "Awards", "account_balance_wallet_outlined",widget.data),
    getCategory(Icons.computer, "Tuition", "computer",widget.data),
    getCategory(Icons.star_border, "Others", "star_border",widget.data),
    addCategory(
    Icons.local_hospital, "Add New", "local_hospital",1)
  ,
    ],
    ),
    ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget addCategory(IconData icon, String categoryName, String iconName,int type) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(children: [
        Ink(
            decoration: ShapeDecoration(
                color: Colors.white54,
                shape: Border.all(
                  color: Colors.green,
                  width: 2.0,
                )),
            child: IconButton(
              icon: new Icon(
                icon,
                color: Colors.green,
              ),
              //tooltip: 'Second splashColor: Colors.redscreen',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddExpenseCategoryScreen(
                          args: new ScreenArguments("Expense Category",
                              Icons.ac_unit, iconName, "", "", "", 1, 1,type), key: GlobalKey(),)),
                );
              },
            )),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              categoryName,
              style: new TextStyle(
                //color: (isPressed) ? Colors.white : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            )),
      ]),
    );
  }

  Widget getCategory(IconData icon, String categoryName, String iconName,int type) {

    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(children: [
        Ink(
            decoration: ShapeDecoration(
              color: Colors.lime[100],
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: new Icon(
               icon,
                color: Colors.indigo,
              ),
              //tooltip: 'Second splashColor: Colors.redscreen',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddExpenseScreen(
                          args: new ScreenArguments(
                              categoryName, icon, iconName, "", "", "", 1, 1,type), key: GlobalKey(),)),
                );
              },
            )),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              categoryName,
              style: new TextStyle(
                //color: (isPressed) ? Colors.white : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            )),
      ]),
    );
  }

  Future<List<Category>> getCategoryList(int swapIndex) {
    var db = new DatabaseHelper();
    return db.getCategories(swapIndex);
  }

  Widget expenseCategoryList(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: getCategoryList(widget.data),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return Padding(
                  padding: EdgeInsets.only(top: 5, left: 15, right: 5),
                  child: expenseCategories(context));
            }
          }
          return Text("");
        });
  }

  Widget expenseCategories(BuildContext context) {
    return new ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          new Container(height: 120.0, child: _customCategories(context)),
        ]);
  }

  Widget _customCategories(BuildContext context) {
    return new FutureBuilder(
        future: getCategoryList(widget.data),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text(""));
          } else {
            return ListView.builder(
                // padding: const EdgeInsets.all(15),
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      new Card(
                        elevation: 2.0,
                        child: new Container(
                          height: MediaQuery.of(context).size.width / 3.8,
                          width: MediaQuery.of(context).size.width / 3,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 10.0),
                          child: getCategory(Icons.ac_unit,
                              snapshot.data![index].categoryName, "ac_unit",widget.data),
                        ),
                      )
                    ],
                  );
                });
          }
        });
  }

  void showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Material(
        //Use a Material Widget
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter text',
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
  }
}
