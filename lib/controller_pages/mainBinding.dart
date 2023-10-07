import 'package:get/get.dart';
import 'package:smartspend/controller_pages/chartsController.dart';
import 'package:smartspend/controller_pages/dashboardController.dart';
import 'package:smartspend/controller_pages/expensesController.dart';
import 'package:smartspend/controller_pages/homeController.dart';
import 'package:smartspend/controller_pages/inComeController.dart';
import 'package:smartspend/controller_pages/loginController.dart';
import 'package:smartspend/controller_pages/mainController.dart';
import 'package:smartspend/controller_pages/personalInformationController.dart';
import 'package:smartspend/controller_pages/postAndPatchCategoriesController.dart';
import 'package:smartspend/controller_pages/postMovmentsController.dart';

class mainBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<mainController>(() => mainController());
    Get.lazyPut<dashboardController>(() => dashboardController());
    Get.lazyPut<homeController>(() => homeController());
    Get.lazyPut<inComeController>(() => inComeController());
    Get.lazyPut<loginController>(() => loginController());
    Get.lazyPut<expensesController>(() => expensesController());
    Get.lazyPut<postMovmentController>(() => postMovmentController());
    Get.lazyPut<chartsController>(() => chartsController());
    Get.lazyPut<postAndPatchCategoriesController>(() => postAndPatchCategoriesController());
    Get.lazyPut<personalInformationController>(() => personalInformationController());
  }
}