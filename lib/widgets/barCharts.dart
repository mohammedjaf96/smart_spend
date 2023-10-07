import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/controller_pages/chartsController.dart';

class barCharts extends GetView<chartsController> {
  const barCharts({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y, {bool isTouched = false, Color? barColor, double width = 22, List<int> showTooltips = const [],}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.deepOrange : Colors.amber,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: const Color(0XFF043cb5),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }


  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, controller.days[6].amount, isTouched: i == controller.touchedIndexBar);
      case 1:
        return makeGroupData(1, controller.days[5].amount, isTouched: i == controller.touchedIndexBar);
      case 2:
        return makeGroupData(2, controller.days[4].amount, isTouched: i == controller.touchedIndexBar);
      case 3:
        return makeGroupData(3, controller.days[3].amount, isTouched: i == controller.touchedIndexBar);
      case 4:
        return makeGroupData(4, controller.days[2].amount, isTouched: i == controller.touchedIndexBar);
      case 5:
        return makeGroupData(5, controller.days[1].amount, isTouched: i == controller.touchedIndexBar);
      case 6:
        return makeGroupData(6, controller.days[0].amount, isTouched: i == controller.touchedIndexBar);
      default:
        return throw Error();
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'الجمعه';
                break;
              case 1:
                weekDay = 'الخميس';
                break;
              case 2:
                weekDay = 'الاربعاء';
                break;
              case 3:
                weekDay = 'الثلاثاء';
                break;
              case 4:
                weekDay = 'الاثنين';
                break;
              case 5:
                weekDay = 'الاحد';
                break;
              case 6:
                weekDay = 'السبت';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              GoogleFonts.almarai(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),

            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = GoogleFonts.almarai(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('جمعه', style: style);
        break;
      case 1:
        text = Text('خميس', style: style);
        break;
      case 2:
        text = Text('اربعاء', style: style);
        break;
      case 3:
        text = Text('ثلاثاء', style: style);
        break;
      case 4:
        text = Text('اثنين', style: style);
        break;
      case 5:
        text = Text('احد', style: style);
        break;
      case 6:
        text = Text('سبت', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
