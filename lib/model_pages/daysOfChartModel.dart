class daysOfChartModel {
  int number;
  String name;
  double amount;
  daysOfChartModel({required this.name,required this.amount, required this.number});


  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
      'amount': amount,
    };
  }
}