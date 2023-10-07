import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboardController.dart';

class homeController extends GetxController {

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

}