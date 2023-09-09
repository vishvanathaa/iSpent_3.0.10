class Expense{
  String entryDate;
  String itemName;
  int itemRate;
  Expense({
    required this.entryDate,
    required this.itemName,
    required this.itemRate
  });
  factory Expense.fromJson(Map<String, dynamic> parsedJson){
    return Expense(
        entryDate: parsedJson['entryDate'],
        itemName : parsedJson['itemName'],
        itemRate : parsedJson['itemRate']
    );
  }
}