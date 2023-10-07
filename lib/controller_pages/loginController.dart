import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screen_pages/profilePage.dart';
import 'mainController.dart';

class loginController extends GetxController {

  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool hidePassword = true.obs;
  RxBool login = true.obs;

  changeHidePassword(){
    hidePassword.value = !hidePassword.value;
  }
  changeLogin(){
    login.value = !login.value;
  }

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

  final FirebaseAuth auth = FirebaseAuth.instance;
  loginFunction()async{
    try {
      changeLoading();
      await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      changeLoading();
      Get.back();
      Get.back();
    } catch (e) {
      showSnakBar('عذرا', 'المعلومات التي ادخلتها غير صحيحه');
      changeLoading();
      print(e);
    }
  }
  signupFunction()async{
    try {
      changeLoading();
      await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      User? user = auth.currentUser;
      if (user != null) {
        await loginFunction();
      }
      changeLoading();
      Get.back();
      Get.back();
    } catch (e) {
      showSnakBar('عذرا', 'المعلومات التي ادخلتها غير صحيحه');
      changeLoading();
      print(e);
    }
  }




  /// for calling and whats app
  void launchUrl(String Url) async {
    if (await canLaunch(Url)) {
      await launch(Url);
    } else {
      throw 'Could not launch url';
    }
  }
  void launchCaller (command) async{
    if(await canLaunch(command)){
      await launch(command);
    }else{
      //Scaffold.of(context).showSnackBar(const SnackBar(content: Text("لا يمكن الاتصال بهذا الرقم",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "Katibeh-Regular"),)));
    }
  }
}