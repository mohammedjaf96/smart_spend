import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/screen_pages/chartsPage.dart';
import 'package:smartspend/screen_pages/postAndPatchCategoriesPage.dart';
import 'package:smartspend/screen_pages/profilePage.dart';

import '../controller_pages/dashboardController.dart';

class homeAppbar extends GetView<dashboardController> {
  const homeAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text('الرئيسية',textAlign: TextAlign.center,
        style: GoogleFonts.almarai(fontSize: 20,fontWeight: FontWeight.normal),),
      leading: IconButton(
        onPressed: (){
          HapticFeedback.mediumImpact();
          Get.to(()=> profilePage(),transition: Transition.fade);
        },
        icon: const Icon(Icons.person_outline_sharp),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: (){
            HapticFeedback.mediumImpact();
            Get.to(()=> chartsPage());
          },
          icon: const Icon(Icons.bar_chart),
        ),
        IconButton(
          onPressed: (){
            HapticFeedback.mediumImpact();
            addNewCategories(context);
          },
          icon: const Icon(Icons.add),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 15,),
              SizedBox(
                width: Get.width,
                height: 50,
                child: Row(
                  children: [
                    Obx(() => _boxWidget(controller.rest.value, controller.rest.value >= 0 ? 'الـبــــاقي' : 'الباقي - صرفت اكثر\nمن الميزانيه')),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white,
                    ),
                    Obx(() => _boxWidget(controller.expenses.value, 'الصرفيات')),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white,
                    ),
                    Obx(() => _boxWidget(controller.budget.value, 'الميزانية')),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              _switchButtons(),
              const SizedBox(height: 15,),
              _dateSelectWidget()
            ],
          ),
        ),
      ), // i use flexibleSpace widget to set custom height
    );
  }



  /// this widget i use it in appbar
  _boxWidget(value,title){
    return SizedBox(
      width: Get.width / 3.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${value.toString()}',textAlign: TextAlign.center,
              style: GoogleFonts.almarai(fontSize: 17,color: Colors.white)),
          const SizedBox(height: 5,),
          Text(title,textAlign: TextAlign.center,
              style: GoogleFonts.almarai(fontSize: 12,color: Colors.white)),
        ],
      ),
    );
  }



  /// this other widget i use it appbar - to switching pages
  _switchButtons(){
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              HapticFeedback.mediumImpact();
              controller.changePageIndex(1);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 35,
              width: (Get.width - 40) / 2,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  color: controller.pageIndex.value == 1 ? const Color(0XFF05d7a3) : const Color(0XFF1c6eac)
              ),
              child: Center(
                child: Text('الـــــدخــل',textAlign: TextAlign.center,
                  style: GoogleFonts.almarai(fontSize: 14,color: Colors.white),),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              HapticFeedback.mediumImpact();
              controller.changePageIndex(0);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 35,
              width: (Get.width - 40) / 2,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: controller.pageIndex.value == 0 ? const Color(0XFF05d7a3) : const Color(0XFF1c6eac)
              ),
              child: Center(
                child: Text('الصــــرفيات',textAlign: TextAlign.center,
                  style: GoogleFonts.almarai(fontSize: 14,color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    ));
  }



  /// i use this widget in appbar
  /// i use it to change the date to filter reports as date selected
  _dateSelectWidget(){
    return Obx(() => Container(
      width: Get.width,
      height: 80,
      color: Colors.grey.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: (){
              controller.changeDate(false);
            },
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(controller.getMonthYearInArabic(controller.dateSelected.value),textAlign: TextAlign.center,
                style: GoogleFonts.almarai(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
              const SizedBox(height: 5,),
              Text(controller.movmentsCount.value.toString() + '   عدد العمليات',textAlign: TextAlign.center,
                style: GoogleFonts.almarai(fontSize: 14,color: Colors.white),),
            ],
          ),
          IconButton(
            onPressed: (){
              controller.changeDate(true);
            },
            icon: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
          ),
        ],
      ),
    ));
  }


  /// add new Categories
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
                  postAndPatchCategoriesPage()
                ],
              ),
            ),

          );
        }
    );
  }
}
