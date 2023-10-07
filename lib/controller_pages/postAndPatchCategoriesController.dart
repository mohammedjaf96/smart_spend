import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class postAndPatchCategoriesController extends GetxController {


  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    checkVisibilityKeyboard();
  }

  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();
    visibilityKeyboard.close();


  }

  RxBool loading = false.obs;
  changeLoading(){
    if(loading.value == true){
      nameOfCategoryController.clear();
      maxbudgetController.clear();
      imageSelected.value = '';
    }else{

    }
    loading.value = !loading.value;
  }

  List<String> imagesList = ['assets/images/food.png','assets/images/doctor.png','assets/images/other.png','assets/images/dollar.png','assets/images/house.png'];
  RxString imageSelected = ''.obs;
  setImage(img){
    imageSelected.value = img;
  }

  TextEditingController nameOfCategoryController = TextEditingController();
  TextEditingController maxbudgetController = TextEditingController();

  /// check if the keyBoard visibility or not
  RxBool visibilityKeyboard = false.obs;
  checkVisibilityKeyboard(){
    KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilityController.onChange.listen((bool visible) {
      visibilityKeyboard.value = visible;
    });
  }



  showSnakBar(title,des){
    Get.snackbar(title, des,
        titleText: Text(title,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),),messageText:
        Text(des,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),));
  }
}