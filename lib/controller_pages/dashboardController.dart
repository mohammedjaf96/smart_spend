import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../model_pages/movementsModel.dart';
import 'mainController.dart';


class dashboardController extends GetxController {

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    setReports();
    getNotifications();
  }

  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();
    pageIndex.close();
    notifications.close();
  }




  /// this for change pages in dashboardPage
  RxInt pageIndex = 0.obs;
  changePageIndex(index){
    pageIndex.value = index;
  }


  /// this function return month name in ar and the year only
  String getMonthYearInArabic(DateTime dateTime) {
    final formatter = DateFormat('MMMM y', 'ar');
    return formatter.format(dateTime);
  }



  /// this for enable notifications of app i use in here SharedPreferences
  RxBool notifications = true.obs;
  changeNotifications(bool state)async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    notifications.value = state;
    perf.setBool('notifications', state);
  }
  getNotifications()async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    if(perf.getBool('notifications') != null){
      notifications.value = perf.getBool('notifications')!;
    }
  }



  /// this for report in Home Appbar
  final _mainController = Get.put(mainController());
  RxDouble budget = 0.0.obs;
  RxDouble expenses = 0.0.obs;
  RxDouble rest = 0.0.obs;
  setReports()async{
    await _mainController.getMovment();
    List<movementsModel> movmentList = _mainController.movmentsList;
    budget.value = movmentList.where((element) => element.type == 'income').fold(0.0, (a, b) => a + double.parse(b.amount.toString()));
    expenses.value = movmentList.where((element) => element.type == 'expenses').fold(0.0, (a, b) => a + double.parse(b.amount.toString()));
    rest.value = budget.value - expenses.value;
    setMovmentsCount();
  }


  /// this.for report as date in Home Appbar
  var dateSelected = DateTime.now().obs;
  RxInt movmentsCount = 0.obs;
  setMovmentsCount() async {
    await _mainController.getMovment();
    DateTime startDate = DateFormat('yyyy-MM').parse(dateSelected.toString());
    List<movementsModel> movmentList =
        _mainController.movmentsList
            .where((element) => DateFormat('yyyy-MM').parse(element.create.toString()) == startDate).toList();
    movmentsCount.value = movmentList.length;
  }
  changeDate(bool plus){
    if(plus){
      dateSelected.value = dateSelected.value.add(const Duration(days: 30));
      setMovmentsCount();
    }else{
      dateSelected.value = dateSelected.value.subtract(const Duration(days: 30));
      setMovmentsCount();
    }
  }



}