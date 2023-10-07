import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/loginController.dart';

import 'mainController.dart';


class personalInformationController extends GetxController{


  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();

  }



  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool loading = false.obs;
  changeLoading(){
    loading.value = !loading.value;
  }

  showSnakBar(title,des){
    Get.snackbar(title, des,
        titleText: Text(title,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),),messageText:
        Text(des,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),));
  }


  final _loginController = Get.put(loginController());



  /// patch personal information data
  patchData() async {
    changeLoading();
    User? user = _loginController.auth.currentUser;
    if(user != null){
      await user.updateDisplayName(nameController.text);
      changeLoading();
      showSnakBar('ممتاز','تم تحديث المعلومات بنجاح');
    }else{
      changeLoading();
    }
  }


  logOut(){
    Get.defaultDialog(
        title: 'هل ترغب بتسجيل الخروج من الحساب ؟',
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
                Get.back();
                await FirebaseAuth.instance.signOut().then((value){
                  Get.back();
                  Get.back();
                });

              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red
                ),
                child: Center(
                  child: Text('خروج',textAlign: TextAlign.center,
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