import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:smartspend/controller_pages/dashboardController.dart';
import 'package:smartspend/controller_pages/homeController.dart';
import 'package:smartspend/model_pages/categoryModel.dart';
import 'package:smartspend/screen_pages/expensesPage.dart';
import 'package:smartspend/screen_pages/postAndPatchCategoriesPage.dart';
import 'package:smartspend/screen_pages/postMovmentPage.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../controller_pages/mainController.dart';

class homePage extends GetView<homeController>{
  homePage({Key? key}) : super(key: key);
  final _mainController = Get.put(mainController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if(_mainController.categoriesList.where((e) => e.type == 'expenses').toList().isEmpty){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ليس لديك اي اقسام حاليا\nقم باضافة قسم اولا',textAlign: TextAlign.center,
              style: GoogleFonts.almarai(fontSize: 14,color: Colors.black54),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: (){
                    HapticFeedback.mediumImpact();
                    addNewCategories(context);
                  },
                  child: Card(
                    elevation: 0.3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    child: Container(
                      width: Get.width,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0XFF043cb5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text('اضافة قسم جديد',textAlign: TextAlign.center,
                          style: GoogleFonts.almarai(fontSize: 13,color: Colors.white),),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }else{
          return ListView.builder(
            itemCount: _mainController.categoriesList.where((e) => e.type == 'expenses').toList().length,
            controller: controller.listviewScrollController,
            itemBuilder: (context,index){
              return _expensesCategoryWidget(_mainController.categoriesList.where((e) => e.type == 'expenses').toList()[index]);
            },
          );
        }
      }),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  /// this widget for Expenses category
  _expensesCategoryWidget(categoryModel model){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: (){
          Get.to(()=> expensesPage(model: model),transition: Transition.fade);
        },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(model.name,textAlign: TextAlign.right,
                      style: GoogleFonts.almarai(fontSize: 13,color: Colors.black54),),
                    const SizedBox(width: 10,),
                    const Icon(Icons.arrow_forward,color: Colors.black54,size: 20,),
                  ],
                ),
                SizedBox(
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
                              color: controller.returnColorForImage(model.image.toString()).withOpacity(0.3)
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(model.image.toString(),height: 40,),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('الميزانيه المحدده : ${model.maxbudget.toString()}',textAlign: TextAlign.right,
                            style: GoogleFonts.almarai(fontSize: 12,color: Colors.black54),),
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: Get.width - 120,
                            child: StepProgressIndicator(
                              totalSteps: model.maxbudget.toInt(),
                              currentStep: model.maxbudget ==  model.currentbudget || model.maxbudget <  model.currentbudget? model.maxbudget.toInt() : (model.currentbudget.toInt()),
                              size: 10,
                              selectedColor: controller.returnColorForImage(model.image.toString()),
                              unselectedColor: Colors.black38,
                              padding: 0,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          model.currentbudget == 0.0 ? const SizedBox() :
                          Text('اخر عملية اضافة : ${intl.DateFormat(_mainController.dateFormat.value).format(DateTime.parse(model.lastpost))}',textAlign: TextAlign.right,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.almarai(fontSize: 12,color: Colors.black54),),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _floatingActionButton(){
    return GestureDetector(
      onTap: (){
        if(_mainController.categoriesList.where((e) => e.type == 'expenses').toList().isEmpty){
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


  addNewCategories(context){
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        elevation: 10,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            )
        ),
        builder: (context){
          return InkWell(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: Get.width,
              decoration: const BoxDecoration(
                  borderRadius:  BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                  ),
                  color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  postAndPatchCategoriesPage(),

                ],
              ),
            ),

          );
        }
    );
  }
}
