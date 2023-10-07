import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mainController.dart';

class expensesController extends GetxController{

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    getMovments();
  }

  final _mainController = Get.put(mainController());

  getMovments()async{
    await _mainController.getMovment();
    update();
  }

  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();
    listviewScrollController.dispose();
  }

  ScrollController listviewScrollController = ScrollController();


  deleteCatagory(id){
    Get.defaultDialog(
        title: 'هل ترغب بحذف القسم بالكامل ؟',
        titleStyle: GoogleFonts.almarai(fontSize: 14,color: Colors.black),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green
                ),
                child: Center(
                  child: Text('الغاء',textAlign: TextAlign.center,
                    style: GoogleFonts.almarai(fontSize: 15,color: Colors.white),),
                ),
              ),
            ),
            InkWell(
              onTap: ()async{
                await await _mainController.deleteCategory('id = ?', id);
                Get.back();
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red
                ),
                child: Center(
                  child: Text('حذف',textAlign: TextAlign.center,
                    style: GoogleFonts.almarai(fontSize: 15,color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        titlePadding: const EdgeInsets.symmetric(vertical: 20)
    );
  }
}