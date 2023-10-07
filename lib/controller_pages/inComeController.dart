import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartspend/controller_pages/mainController.dart';
import 'package:smartspend/model_pages/movementsModel.dart';

class inComeController extends GetxController {

  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();
    listviewScrollController.dispose();
  }



  ScrollController listviewScrollController = ScrollController();

  Color returnColorForImage(value){
    if(value == 'assets/images/food.png'){
      return Colors.orange;
    }else if(value == 'assets/images/other.png'){
      return Colors.amber;
    }else if(value == 'assets/images/dollar.png'){
      return Colors.green;
    }else if(value == 'assets/images/doctor.png'){
      return Colors.blue;
    }else{
      return Colors.pink;
    }
  }


  /// this function to get total incomes
   getTotalBudget(id){
    final _mainController = Get.put(mainController());
    _mainController.getMovment();
    List<movementsModel> movmentList = _mainController.movmentsList.where((element) => element.catagoryid == id).toList();
    if(movmentList.fold(0.0, (a, b) => a + double.parse(b.amount.toString())).toInt() == 0){
      return null;
    }else{
      return movmentList.fold(0.0, (a, b) => a + double.parse(b.amount.toString()));
    }
  }
}