import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/dashboardController.dart';
import 'package:smartspend/controller_pages/postMovmentsController.dart';
import 'package:smartspend/model_pages/movementsModel.dart';

import '../controller_pages/mainController.dart';

class postMovmentPage extends StatefulWidget {
  postMovmentPage({Key? key}) : super(key: key);

  @override
  State<postMovmentPage> createState() => _postMovmentPageState();
}

class _postMovmentPageState extends State<postMovmentPage> {
  final _mainController = Get.put(mainController());
  final _dashboardController = Get.put(dashboardController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<postMovmentController>(
      init: postMovmentController(),
      builder: (controller){
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              elevation: 0,
              title: Text('اضافة صرفيات',textAlign: TextAlign.center,
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

              ),
            ),// Adjust the preferred height as needed
          ),
          body: GestureDetector(
            onTap: (){
              if(controller.visibilityKeyboard){
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('اختر القسم المراد اضافة الصرفيات له',textAlign: TextAlign.right,
                      style: GoogleFonts.almarai(fontSize: 14,color: Colors.black),),
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    height: 90,
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        reverse: true,
                        itemCount:  _mainController.categoriesList.where((e) => e.type == (_dashboardController.pageIndex.value == 0 ? 'expenses' : 'income')).toList().length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                          var model = _mainController.categoriesList.where((e) => e.type == (_dashboardController.pageIndex.value == 0 ? 'expenses' : 'income')).toList()[index];
                          return InkWell(
                            onTap: (){
                              controller.selectCategory(model);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 0.1,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.green.withOpacity(0.3)
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset(model.image.toString(),height: 40,),
                                  ),
                                ),
                                Text(model.name,textAlign: TextAlign.center,
                                  style: GoogleFonts.almarai(fontSize: 13,color: Colors.black),),
                                const SizedBox(height: 3,),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  height: 3,
                                  width: 50,
                                  color: controller.categorySelected == null ? Colors.transparent : (controller.categorySelected!.id == model.id ? Colors.indigoAccent : Colors.transparent),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.right,
                          controller: controller.amountController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // السماح بالأرقام والنقطة
                          ],
                          style: GoogleFonts.almarai(fontSize: 16,color: Colors.black87,),
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: const Icon(Icons.edit,color: Colors.black87,),
                            hintText: 'المبلغ',
                            fillColor: Colors.white,
                            hintStyle: GoogleFonts.almarai(fontSize: 16,color: Colors.black,),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black54),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black54),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black54),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: null,
                          textAlign: TextAlign.right,
                          controller: controller.noteController,

                          style: GoogleFonts.almarai(fontSize: 16,color: Colors.black87,),
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: const Icon(Icons.edit,color: Colors.black87,),
                            hintText: 'اي ملاحظات ان وجدت',
                            fillColor: Colors.white,
                            hintStyle: GoogleFonts.almarai(fontSize: 16,color: Colors.black,),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black54),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black54),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black54),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: InkWell(
                      onTap: ()async{
                        postMovment(controller);
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
                            child: Text('اضافة المبلغ',textAlign: TextAlign.center,
                              style: GoogleFonts.almarai(fontSize: 13,color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  postMovment(postMovmentController controller)async{
    if(controller.categorySelected == null || controller.amountController.text == ''){
      controller.showSnakBar('تنبيه', 'قم باختيار القسم و اضافه القيمة اولا');
    }else{
      await controller.changeLoading();
      movementsModel _categoryModel =
      movementsModel(
        note: controller.noteController.text,
        type: _dashboardController.pageIndex.value == 0 ? 'expenses' : 'income',
        amount: double.parse(controller.amountController.text),
        create: DateTime.now().toString(), catagoryid: controller.categorySelected!.id!,
      );
      var response = await _mainController.postMovement(_categoryModel.toMap(),controller.categorySelected!);
      await controller.changeLoading();
      await _dashboardController.setReports();
      controller.amountController.clear();
      controller.noteController.clear();
      if(_dashboardController.pageIndex.value == 0){
        await controller.scheduleNotifications(DateTime.now().add(const Duration(minutes: 1)),'تنبيه','لقد تم اضافة مبلغ و قدره ${controller.amountController.text} الى القسم ${controller.categorySelected!.name} قبل دقيقه من الان');
        Get.back();
      }else{}
      Get.back();
      if(response != 0){
        Get.back();
        controller.showSnakBar('احسنت', 'تمت الاضافه بنجاح');
      }else{
        controller.showSnakBar('تنبيه', 'لم يتم الاضافه');
      }
    }
  }
}
