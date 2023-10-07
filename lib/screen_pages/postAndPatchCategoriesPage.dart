import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/dashboardController.dart';
import 'package:smartspend/controller_pages/mainController.dart';
import 'package:smartspend/controller_pages/postAndPatchCategoriesController.dart';
import 'package:smartspend/model_pages/categoryModel.dart';
import 'package:smartspend/widgets/loading.dart';

class postAndPatchCategoriesPage extends GetView<postAndPatchCategoriesController> {
  postAndPatchCategoriesPage({Key? key}) : super(key: key);

  final _dashboardController = Get.put(dashboardController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30,left: 20,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('ادخل معلومات القسم المراد اضافته',textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 14,color: Colors.black87),),
          const SizedBox(height: 5,),
          textFormField('اسم القسم',controller.nameOfCategoryController,false),
          _dashboardController.pageIndex.value == 0 ?
          textFormField('اقصى حد للميزانيه',controller.maxbudgetController,true) : const SizedBox(),
          dropListForImage(context),
          const SizedBox(height: 10,),
          Obx((){
            if(controller.loading.value){
              return const loading();
            }else{
              return InkWell(
                onTap: ()async{
                  if(_dashboardController.pageIndex.value == 0){
                    await postExpenses();
                  }else{
                    await postInCome();
                  }
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
                      child: Text('اضافة القسم',textAlign: TextAlign.center,
                        style: GoogleFonts.almarai(fontSize: 13,color: Colors.white),),
                    ),
                  ),
                ),
              );
            }
          }),
          const SizedBox(height: 15,),
          Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height:  controller.visibilityKeyboard.value ? 300 : 0,
            width: Get.width,
          ))
        ],
      ),
    );
  }

  Widget textFormField(String hintText,TextEditingController _textEditingController,bool number){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          keyboardType: TextInputType.text,
          textAlign: TextAlign.right,
          controller: _textEditingController,
          inputFormatters: number ? [
            FilteringTextInputFormatter.digitsOnly
          ] : [],
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.black87,),
          decoration: InputDecoration(
            filled: true,
            suffixIcon: const Icon(Icons.edit,color: Colors.black87,),
            hintText: hintText,
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
    );
  }


  dropListForImage(context){
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (item) => onSelected(context, item,),
      itemBuilder: (BuildContext context)=> controller.imagesList.map((e){
        return PopupMenuItem<String>(
          value: e,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            elevation: 0.1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue.withOpacity(0.2)
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(e,height: 40,),
            ),
          ),
        );
      }).toList(),
      elevation: 20,
      color: Colors.white,
      tooltip: 'اختيار صوره للقسم',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_drop_down,color: Colors.black,),
          Obx(() => Text(controller.imageSelected.value == ''  ?  'اختر صوره للقسم' : 'تم اختيار صوره للقسم',textAlign: TextAlign.right,
            style: GoogleFonts.almarai(fontSize: 14,color: Colors.black87),)),
        ],
      ),
    );
  }
  Future<void> onSelected (BuildContext context,  item) async {
    controller.setImage(item);
  }

  /// post expenses to mysql lite
  postExpenses() async {
    if(controller.nameOfCategoryController.text == '' || controller.imageSelected.value.toString() == '' || controller.maxbudgetController.text == ''){
      controller.showSnakBar('عذرا', 'من فضلك قم بملئ كل المعلومات من ضمنها الصوره');
    }else{
      await controller.changeLoading();
      final c = Get.put(mainController());
      categoryModel _categoryModel =
      categoryModel(
        name: controller.nameOfCategoryController.text,
        image: controller.imageSelected.value.toString(),
        lastpost: DateTime.now().toString(),
        create: DateTime.now().toString(),
        maxbudget: double.parse(controller.maxbudgetController.text),
        currentbudget: 0.0,
        type: 'expenses',
      );

      var response = await c.postCategories(_categoryModel.toMap());
      await controller.changeLoading();
      await _dashboardController.setReports();
      if(response != 0){
        Get.back();
        controller.showSnakBar('احسنت', 'تمت الاضافه بنجاح');
      }else{
        controller.showSnakBar('تنبيه', 'لم يتم الاضافه');
      }
    }
  }

  /// post incomes to mysql lite
  postInCome() async {
    if(controller.nameOfCategoryController.text == '' || controller.imageSelected.value.toString() == ''){
      controller.showSnakBar('عذرا', 'من فضلك قم بملئ كل المعلومات من ضمنها الصوره');
    }else{
      await controller.changeLoading();
      final c = Get.put(mainController());
      categoryModel _categoryModel =
      categoryModel(
          name: controller.nameOfCategoryController.text,
          image: controller.imageSelected.value.toString(),
          create: DateTime.now().toString(),
          lastpost: DateTime.now().toString(),
          maxbudget: 0.0,
          type: 'income',
          currentbudget: 0.0
      );
      var response = await c.postCategories(_categoryModel.toMap());
      await controller.changeLoading();
      if(response != 0){
        Get.back();
        controller.showSnakBar('احسنت', 'تمت الاضافه بنجاح');
      }else{
        controller.showSnakBar('تنبيه', 'لم يتم الاضافه');
      }
    }
  }
}
