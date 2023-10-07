import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/dashboardController.dart';
import 'package:smartspend/screen_pages/homeAppbar.dart';
import 'package:smartspend/screen_pages/homePage.dart';
import 'package:smartspend/screen_pages/inCome.dart';

class dashboardPage extends StatefulWidget {
  dashboardPage({Key? key}) : super(key: key);

  @override
  State<dashboardPage> createState() => _dashboardPageState();
}

class _dashboardPageState extends State<dashboardPage> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<dashboardController>(
      builder: (controller){
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(250.0), // Adjust the preferred height as needed
            child: homeAppbar(),
          ),
          body: Obx(()=> IndexedStack(
            index: controller.pageIndex.value,
            children: [
              homePage(),
              inComePage()
            ],
          )),
        );
      },
    );

  }


}


