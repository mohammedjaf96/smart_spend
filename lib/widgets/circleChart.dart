import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/chartsController.dart';

import '../controller_pages/dashboardController.dart';


class circleChart extends GetView<chartsController> {
  circleChart({Key? key}) : super(key: key);

  final _dashboardController = Get.put(dashboardController());

  @override
  Widget build(BuildContext context) {
    if(_dashboardController.budget.value == 0 && _dashboardController.rest.value == 0 && _dashboardController.expenses.value == 0){
      return Center(
        child: Text('لا تتوفر اي تقارير او احصائيات حاليا',textAlign: TextAlign.center,
        style: GoogleFonts.almarai(fontSize: 13,color: Colors.black),),
      );
    }else{
      return Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child:  PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            controller.touchedIndexCircle = -1;
                            return;
                          }
                          controller.touchedIndexCircle = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections()),
              ),
            ),
          ),
          const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:  <Widget>[
              Indicator(
                color: Colors.indigoAccent,
                text: 'الدخل',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.deepOrange,
                text: 'الصرفيات',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.purple,
                text: 'الباقي',
                isSquare: true,
              ),
            ],
          ),
          const SizedBox(
            width: 18,
          ),
        ],
      );
    }
  }


  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == controller.touchedIndexCircle;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.indigoAccent,
            value: _dashboardController.budget.value,
            title: _dashboardController.budget.value.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
              color: Colors.white,),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.deepOrange,
            value: _dashboardController.expenses.value,
            title: _dashboardController.expenses.value.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
              color: Colors.white,),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: _dashboardController.rest.value,
            title: _dashboardController.rest.value.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}



class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

   const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(text,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 13,color: Colors.black),),
        const SizedBox(
          width: 4,
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
      ],
    );
  }
}