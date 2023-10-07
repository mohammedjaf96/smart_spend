import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/chartsController.dart';
import 'package:smartspend/widgets/circleChart.dart';
import 'package:smartspend/widgets/loading.dart';

import '../widgets/barCharts.dart';

class chartsPage extends StatelessWidget {
  chartsPage({Key? key}) : super(key: key);


  final _chartsController = Get.put(chartsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          title: Text('الاحصائيات و التقارير',textAlign: TextAlign.center,
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


                ],
              ),
            ),
          ),
        ),// Adjust the preferred height as needed
      ),
      body: ListView(
        children: [
          Card(
            elevation: 0.4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Container(
              width: Get.width,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              child: circleChart(),
            ),
          ),
          _chartsController.loading ? const loading() : Card(
            elevation: 0.4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Container(
              width: Get.width,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              child: const barCharts(),
            ),
          )
        ],
      ),
    );
  }
}
