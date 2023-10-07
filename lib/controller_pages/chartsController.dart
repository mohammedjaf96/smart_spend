import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartspend/controller_pages/mainController.dart';
import 'package:smartspend/model_pages/daysOfChartModel.dart';
import 'package:smartspend/model_pages/movementsModel.dart';

import 'dashboardController.dart';

class chartsController extends GetxController{


  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    filterMovementsAsDays();
  }

  int touchedIndexCircle = -1;
  int touchedIndexBar = -1;

  final _mainController = Get.put(mainController());
  /// in here i filter the movement of money as date to put it in bar chart
  List<daysOfChartModel> days = [];
  List<String> nameOfDays = ['السبت','الأحد','الاثنين','الثلاثاء','الأربعاء','الخميس','الجمعة'];
  bool loading = true;
  filterMovementsAsDays(){
    /// here get all movements of expenses
    List<movementsModel> movements = _mainController.movmentsList.where((element) => element.type == 'expenses').toList();
    for(int i = 0; i <= 6; i++){ // here i set for loop as 7 days
      days.add(daysOfChartModel(name: nameOfDays[i], amount: 0, number: i+1));
      for (var element in movements) { // here i set loop as movements
        /// here i check if the name of days has movement will be add == the first day on my list
        if(DateFormat('EEEE', 'ar').format(DateTime.parse(element.create.toString())) == nameOfDays[i]){
          days[i].amount =  days[i].amount + element.amount;
        }
      }
    }
    loading = false;
    update();
  }

}