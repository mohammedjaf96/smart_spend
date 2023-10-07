import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/personalInformationController.dart';
import 'package:smartspend/widgets/loading.dart';

class personalInformations extends StatelessWidget {
  personalInformations({Key? key}) : super(key: key);

  final controller = Get.put(personalInformationController());
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
          actions: [
            IconButton(
              onPressed: (){
                controller.logOut();
              },
              icon: const Icon(Icons.outbound_outlined,color: Colors.white,),
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
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 150,),
                  textFormField('الاسم',controller.nameController,false),
                  textFormField('الايميل',controller.emailController,true),
                  textFormField('كلمة المرور',controller.passwordController,true),
                  Obx(() {
                    if(controller.loading.isTrue){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10,),
                          const loading(),
                          Text('هناك بطئ في حفظ البيانات و كذلك التسجيل\nالسبب يعود الى Firebase',textAlign: TextAlign.center,
                          style: GoogleFonts.almarai(fontSize: 13,color: Colors.white),)
                        ],
                      );
                    }else{
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: InkWell(
                          onTap: (){
                            controller.patchData();
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
                                child: Text('حفظ',textAlign: TextAlign.center,
                                  style: GoogleFonts.almarai(fontSize: 13,color: Colors.white),),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  })
                ],
              ),
            ),
          ),
        ),// Adjust the preferred height as needed
      ),
    );
  }


  Widget textFormField(String hintText,TextEditingController _textEditingController,bool readOnly){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textAlign: TextAlign.right,
            readOnly: readOnly,
            controller: _textEditingController,
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
      ),
    );
  }
}


