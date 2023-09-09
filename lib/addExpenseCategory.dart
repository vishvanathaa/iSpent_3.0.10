import 'package:flutter/material.dart';
import 'package:ispent/database/model/category.dart';
import 'package:ispent/screenarguments.dart';
import 'package:ispent/database/database_helper.dart';
import 'dart:async';

import 'expense.dart';

class AddExpenseCategoryScreen extends StatefulWidget {
  final ScreenArguments args;

  AddExpenseCategoryScreen({required Key key,  required this.args}) : super(key: key);

  @override
  _AddExpenseCategoryState createState() => _AddExpenseCategoryState();
}

class _AddExpenseCategoryState extends State<AddExpenseCategoryScreen> {
  TextEditingController categoryController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPressed = false;

  //bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        title: Text(widget.args.type==0?"Add Expense Category":"Add Income Category"),
      ),
      resizeToAvoidBottomInset: false,

      //resizeToAvoidBottomPadding: false,
      body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                child: Column(children: [
                  IconButton(
                    icon: new Icon(
                      widget.args.icon,
                      color: Colors.indigo,
                      size: 35,
                    ),
                    onPressed: () {},
                    //tooltip: 'Second screen',
                    color: Colors.indigo,
                  ),
                  Text(
                    widget.args.type == 1?"Income Category" : widget.args.title,
                    style: new TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ]),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                  //    color:  Colors.indigo
                ),
                //color: Colors.green[100],
              ),
              Container(
                  padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: new TextFormField(
                          controller: categoryController,
                          maxLength: 25,
                          decoration: new InputDecoration(
                            labelText: "Enter category here.",
                            fillColor: Colors.indigo,
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            //hintText: 'Tell us about yourself',
                            helperText:
                                'Keep it short so it is fit into screen.',
                            prefixIcon: const Icon(
                              Icons.edit,
                              color: Colors.indigo,
                            ),
                          ),
                          validator: (String? arg) {
                            if (arg!.length < 1)
                              return 'Enter category';
                            else
                              return null;
                          },
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ],
                  )),
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(color: Colors.white),
                          backgroundColor: widget.args.type==0?Colors.indigo:Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        icon: const Icon(Icons.save, color: Colors.white),
                        //`Icon` to display
                        label: Text(
                          widget.args.type==0?'SAVE EXPENSE CATEGORY': 'SAVE INCOME CATEGORY',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          // Add your onPressed code here!
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            addRecord(widget.args.type);
                            //Navigator.pushNamed(context, '/expense');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ExpenseScreen(data: widget.args.type, key: GlobalKey(),),
                              ),
                            );
                            //new ExpenseScreen(data: widget.args.type, key: GlobalKey());
                          } else {
                            //    If all data are not valid then start auto validation.
                            setState(() {
                              //_autoValidate = true;
                            });
                          }
                        },
                      ))),
            ],
          )),
    );
  }

  Future addRecord(int swapIndex) async {
    var db = new DatabaseHelper();
    var category = new Category(
      categoryController.text,swapIndex
    );
    await db.addCategory(category);
  }
}
