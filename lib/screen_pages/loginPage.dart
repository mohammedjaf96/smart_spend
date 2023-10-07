import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/loginController.dart';
import 'package:smartspend/widgets/loading.dart';

class loginPage extends GetView<loginController> {
  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          /// i use this js to pop out keyboard when use tap on screen
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white
                          ),
                          child: const Center(
                            child: Icon(Icons.close,color: Colors.black87,),
                          ),
                        ),
                      ),
                      Obx(() => Text(controller.login.value ? 'سجل الدخول الى حسابك' : 'انشاء حساب جديد',textAlign: TextAlign.right,
                        style: GoogleFonts.almarai(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                ClipRRect(borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/logo.png',height: 70,)),
                const SizedBox(height: 20,),
                Text('مرحبا',textAlign: TextAlign.right,
                  style: GoogleFonts.almarai(fontSize: 18,color: Colors.black),),
                const SizedBox(height: 5,),
                Obx(() => Text(controller.login.value ? 'يرجى ملئ المعلومات لاكمال التسجيل' : 'ادخل المعلومات المطلوبه لانشاء حساب',textAlign: TextAlign.right,
                  style: GoogleFonts.almarai(fontSize: 16,color: Colors.black54),)),
                const SizedBox(height: 15,),
                textFormFieldPhone(),
                const SizedBox(height: 5,),
                Obx(() => textFormFieldPassword()),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){controller.changeLogin();},
                        child: Obx(()=> Text(
                          controller.login.value ? 'اذا لم يكن لديك حساب اضغط هنا لانشاء حساب'
                              : 'اذا كان لديك حساب سابقا اضغط هنا لتسجيل الدخول',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.almarai(fontSize: 13,color: Colors.indigoAccent),
                        ))
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7,),
                Obx((){
                  if(controller.loading.isTrue){
                    return const loading();
                  }else{
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: InkWell(
                        onTap: () async {
                          if(controller.emailController.text == '' || controller.passwordController.text == ''){
                            controller.showSnakBar('عذرا', 'قم بملئ المعلومات اولا');
                          }else{
                            if(controller.login.isTrue){
                              await controller.loginFunction();
                            }else{
                              await controller.signupFunction();
                            }
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
                              gradient: const LinearGradient(
                                colors: [Color(0XFF043cb5),Color(0XFF06a181)],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(controller.login.value ? 'سجل الدخول الى حسابك' : 'انشاء حساب جديد',textAlign: TextAlign.center,
                                style: GoogleFonts.almarai(fontSize: 13,color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget textFormFieldPhone(){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.left,
          controller: controller.emailController,

          style: GoogleFonts.almarai(fontSize: 16,color: Colors.black87,),
          decoration: InputDecoration(
            filled: true,
            suffixIcon: SizedBox(
              width: 60,
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.black.withOpacity(0.5),
                    margin: const EdgeInsets.only(right: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.email_outlined,color: Colors.black54,),
                  ),
                ],
              ),
            ),
            hintText: 'Email',
            prefixStyle:  GoogleFonts.almarai(fontSize: 14,color: Colors.black),
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
  Widget textFormFieldPassword(){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: controller.hidePassword.value,
          textAlign: TextAlign.left,
          controller: controller.passwordController,

          style: GoogleFonts.almarai(fontSize: 16,color: Colors.black54,),
          decoration: InputDecoration(
            filled: true,
            suffixIcon: SizedBox(
              width: 60,
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.black,
                    margin: const EdgeInsets.only(right: 10),
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.vpn_key,color: Colors.black54,),
                  ),
                ],
              ),
            ),
            prefixIcon: InkWell(
              onTap: (){
                controller.changeHidePassword();
              },
              child: Icon(Icons.remove_red_eye_outlined,color: controller.hidePassword.value ? Colors.black54 : Colors.black12,),
            ),
            hintText: 'كلمة المرور',
            prefixStyle:  GoogleFonts.almarai(fontSize: 14,color: Colors.black87),
            fillColor: Colors.white,
            hintStyle: GoogleFonts.almarai(fontSize: 16,color: Colors.black87,),
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



}
