import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:blend/components/appBars/main_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sfc;
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:animated_digit/animated_digit.dart';

class PlatformAnalyticsPage extends StatefulWidget {
  @override
  State<PlatformAnalyticsPage> createState() => _PlatformAnalyticsPageState();
}

class _PlatformAnalyticsPageState extends State<PlatformAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Navigator.pushNamed(context , 'analytics/');
          Navigator.pop(context);
        },
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Title(
                    color: Color(0xFFFFFFFF),
                    child: Text(
                      "Platform Name",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color.fromARGB(255, 255, 255, 255),
                    thickness: 3.0,
                    indent: 12.0,
                    endIndent: 12.0,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        // width: 150.0,
                        height: 150.0,
                        child: sfc.SfCartesianChart(
                          // Initialize category axis
                          primaryXAxis: sfc.CategoryAxis(),

                          series: <sfc.LineSeries<SalesData, String>>[
                            sfc.LineSeries<SalesData, String>(
                              // Bind data source
                              dataSource: <SalesData>[
                                SalesData('Jan', 75),
                                SalesData('Feb', 8),
                                SalesData('Mar', 64),
                                SalesData('Apr', 60),
                                SalesData('May', 70)
                              ],
                              xValueMapper: (SalesData sales, _) => sales.year,
                              yValueMapper: (SalesData sales, _) => sales.sales,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 255, 255, 255),
                    thickness: 3.0,
                    indent: 12.0,
                    endIndent: 12.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.all(35.0),
                                decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 10,
                                  ),
                                ),
                                child: AnimatedDigitWidget(
                                  value: 12332,
                                  textStyle: TextStyle(
                                    color: Colors.green[800],
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              pie.PieChart(
                                ringStrokeWidth: 20,
                                dataMap: <String, double>{
                                  "instagram": 223,
                                  "TikTok": 150,
                                  "Youtube": 21,
                                  "other": 120,
                                },
                                chartLegendSpacing: 20,
                                chartType: pie.ChartType.ring,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 2.8,
                                legendOptions: pie.LegendOptions(
                                    showLegends: false,
                                    showLegendsInRow: true,
                                    legendPosition: pie.LegendPosition.bottom),
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
