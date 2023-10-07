import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smartspend/controller_pages/expensesController.dart';
import 'package:smartspend/controller_pages/homeController.dart';
import 'package:smartspend/controller_pages/inComeController.dart';
import 'package:smartspend/controller_pages/mainController.dart';
import 'package:smartspend/model_pages/movementsModel.dart';
import 'package:smartspend/screen_pages/postMovmentPage.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../controller_pages/dashboardController.dart';
import '../model_pages/categoryModel.dart';

class expensesPage extends StatefulWidget {
  categoryModel model;
  expensesPage({Key? key,required this.model}) : super(key: key);

  @override
  State<expensesPage> createState() => _expensesPageState();
}

class _expensesPageState extends State<expensesPage> {
  
  final _homeController = Get.put(homeController());
  final _mainController = Get.put(mainController());
  final _inComeController = Get.put(inComeController());



  @override
  Widget build(BuildContext context) {
    return GetBuilder<expensesController>(
      init: expensesController(),
      builder: (controller){
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: AppBar(
              elevation: 0,
              title: Text('قائمة مصاريف\n${widget.model.name}',textAlign: TextAlign.center,
                style: GoogleFonts.almarai(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.white),),
              leading: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back,color: Colors.white,),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await controller.deleteCatagory(widget.model.id);
                  },
                  icon: const Icon(Icons.delete_outline_outlined,color: Colors.white,),
                ),
              ],
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0XFF043cb5),Color(0XFF06a181)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: Get.width,
                    height: 80,
                    color: Colors.grey.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 0.1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: _homeController.returnColorForImage(widget.model.image.toString()).withOpacity(0.3)
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(widget.model.image.toString(),height: 40,),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('الميزانيه المحدده : ${widget.model.maxbudget.toString()}',textAlign: TextAlign.right,
                                style: GoogleFonts.almarai(fontSize: 12,color: Colors.white),),
                              const SizedBox(height: 5,),
                              SizedBox(
                                width: Get.width - 120,
                                child: widget.model.type == 'income' ? StepProgressIndicator(
                                  totalSteps: _inComeController.getTotalBudget(widget.model.id) == null ? 100 : _inComeController.getTotalBudget(widget.model.id).toInt(),
                                  currentStep: 5,
                                  size: 10,
                                  selectedColor: _inComeController.getTotalBudget(widget.model.id) == null ? Colors.black54 : _inComeController.returnColorForImage(widget.model.image.toString()),
                                  unselectedColor: _inComeController.getTotalBudget(widget.model.id) == null ? Colors.black54 : _inComeController.returnColorForImage(widget.model.image.toString()),
                                  padding: 0,
                                ) : StepProgressIndicator(
                                  totalSteps: widget.model.maxbudget.toInt(),
                                  currentStep: widget.model.maxbudget ==  widget.model.currentbudget || widget.model.maxbudget <  widget.model.currentbudget ? widget.model.maxbudget.toInt() : (widget.model.currentbudget.toInt()),
                                  size: 10,
                                  selectedColor: const Color(0XFF06a181),
                                  unselectedColor: Colors.grey.withOpacity(0.4),
                                  padding: 0,
                                ),
                              ),
                              const SizedBox(height: 5,),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),// Adjust the preferred height as needed
          ),
          body: body(),
          floatingActionButton: _floatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        );
      },
    );
  }

  _expensesWidget(movementsModel model){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 0.1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('تم صرف مبلغ :  ${model.amount.toString()}',textAlign: TextAlign.right,
                style: GoogleFonts.almarai(fontSize: 13,color: Colors.black54),),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(model.note == '' ? 'لا توجد اي ملاحظات' : model.note,textAlign: TextAlign.right,
                    style: GoogleFonts.almarai(fontSize: 13,color: Colors.black54),),
                  Text(' :  الملاحظات',textAlign: TextAlign.right,
                    style: GoogleFonts.almarai(fontSize: 13,color: Colors.black54),),
                ],
              ),
              const SizedBox(height: 20,),
              Text('تاريخ الاضافه :  ${DateFormat(_mainController.dateFormat.value).format(DateTime.parse(model.create))}',textAlign: TextAlign.right,
                style: GoogleFonts.almarai(fontSize: 13,color: Colors.black54),),

            ],
          ),
        ),
      ),
    );
  }


  body(){
    if(_mainController.movmentsList.where((e) => e.catagoryid == widget.model.id).toList().isEmpty){
      return Center(
        child: Text(widget.model.type == 'income' ? 'لا توجد اي مبالغ مدخله الى الحساب' : 'لا توجد اي صرفيات هنا حاليا',textAlign: TextAlign.center,
          style: GoogleFonts.almarai(fontSize: 14,color: Colors.black54),),
      );
    }else{
      return ListView.builder(
        itemCount: _mainController.movmentsList.where((e) => e.catagoryid == widget.model.id).toList().length,
        itemBuilder: (context,index){
          return _expensesWidget(_mainController.movmentsList.where((e) => e.catagoryid == widget.model.id).toList()[index]);
        },
      );
    }
  }
  _floatingActionButton(){
    return GestureDetector(
      onTap: (){
        if(_mainController.categoriesList.where((e) => widget.model.type == 'income' ? (e.type == 'income') : (e.type == 'expenses')).toList().isEmpty){
          _mainController.showSnakBar('تنبيه', 'عذرا قم باضافة قسم اولا');
        } else{
          Get.to(()=> postMovmentPage(),transition: Transition.fade);
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0XFF043cb5),Color(0XFF06a181)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Center(
            child: Text('+',textAlign: TextAlign.center,
              style: GoogleFonts.almarai(height: 0.8,fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}
