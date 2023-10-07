import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/mainController.dart';
import 'package:smartspend/screen_pages/loginPage.dart';
import 'package:smartspend/screen_pages/personalInformations.dart';

import '../controller_pages/dashboardController.dart';
import '../controller_pages/loginController.dart';
import '../widgets/loading.dart';




class profilePage extends GetView<dashboardController>{
  profilePage({Key? key}) : super(key: key);


  final _loginController = Get.put(loginController());
  final _mainController = Get.put(mainController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.height),
        child: AppBar(
          elevation: 0,
          title: Text('المعلومات الشخصية',textAlign: TextAlign.center,
            style: GoogleFonts.almarai(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.white),),
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0XFF043cb5),Color(0XFF06a181)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 150,),

                  _loginController.auth.currentUser == null ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: (){
                        logIn(context);
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
                            child: Text('سجل الدخول الى حسابك',textAlign: TextAlign.center,
                              style: GoogleFonts.almarai(fontSize: 13,color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ) :
                  GestureDetector(
                    onTap: (){
                      Get.to(()=>  personalInformations(),transition: Transition.fade);
                    },
                    child: _boxWidget(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.person_outline_sharp,color: Colors.white,),
                        Text('الملف الشخصي',textAlign: TextAlign.right,
                          style: GoogleFonts.almarai(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    )),
                  ),

                  _boxWidget(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Switch(
                        value: controller.notifications.value,
                        onChanged: (v){
                          HapticFeedback.mediumImpact();
                          controller.changeNotifications(v);
                        },
                        activeColor: const Color(0XFF043cb5),
                      )),
                      Text('الاشعارات',textAlign: TextAlign.right,
                        style: GoogleFonts.almarai(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                    ],
                  )),
                  GestureDetector(
                    onTap: (){_mainController.selectDateFormat(listOfDateFormat());},
                    child: _boxWidget(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.date_range_outlined,color: Colors.white,),
                        Text('تنسيق عرض التاريخ',textAlign: TextAlign.right,
                          style: GoogleFonts.almarai(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    )),
                  ),
                  GestureDetector(
                    onTap: (){
                      _loginController.launchCaller('tel:07719019877');
                    },
                    child: _boxWidget(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.phone,color: Colors.white,),
                        Text('هاتف',textAlign: TextAlign.right,
                          style: GoogleFonts.almarai(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    )),
                  ),
                  GestureDetector(
                    onTap: (){
                      _loginController.launchUrl('https://wa.me/9647719019877');
                    },
                    child: _boxWidget(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.phone,color: Colors.white,),
                        Text('Whats App',textAlign: TextAlign.right,
                          style: GoogleFonts.almarai(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    )),
                  ),

                ],
              ),
            ),
          ),
        ),// Adjust the preferred height as needed
      ),
    );
  }
  _boxWidget(Widget widget){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 0.3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        color: Colors.white.withOpacity(0.15),
        child: Container(
          width: Get.width,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.white.withOpacity(0.15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: widget,
        ),
      ),
    );
  }

  logIn(context){
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: loginPage())
                ],
              ),
            ),

          );
        }
    );
  }

  listOfDateFormat(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _mainController.formatList.map((e){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: GestureDetector(
              onTap: ()async {
                await _mainController.saveDateFormat(e);
                Get.back();
              },
              child: Container(
                width: Get.width,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0XFF043cb5).withOpacity(0.7)
                ),
                child: Center(
                  child: Text(e,textAlign: TextAlign.center,
                    style: GoogleFonts.almarai(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
