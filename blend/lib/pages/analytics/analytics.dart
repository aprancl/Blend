import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:blend/components/appBars/main_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sfc;
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final dataMap = <String, double>{
    "instagram": 543,
    "TikTok": 1000,
    "Youtube": 1221,
    "other": 900,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar().build(context),
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
                      "Analytics Home",
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
                      pie.PieChart(
                        ringStrokeWidth: 20,
                        dataMap: dataMap,
                        chartLegendSpacing: 20,
                        chartType: pie.ChartType.ring,
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                        legendOptions: pie.LegendOptions(
                            showLegends: false,
                            showLegendsInRow: true,
                            legendPosition: pie.LegendPosition.bottom),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Title(
                            color: Color(0xFFFFFFFF),
                            child: Text(
                              "Followers",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 100.0,
                            color: Colors.grey,
                            child: Text("Place holder"),
                          )
                        ],
                      )
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          PlatformEntry(
                            mediaName: "Youtube",
                            icon: Icons.arrow_forward_outlined,
                          ),
                          PlatformEntry(
                            mediaName: "Instagram",
                            icon: Icons.arrow_forward_outlined,
                          ),
                          PlatformEntry(
                            mediaName: "TikTok",
                            icon: Icons.arrow_forward_outlined,
                          ),
                          PlatformEntry(
                            mediaName: "SnapChat",
                            icon: Icons.arrow_forward_outlined,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlatformEntry extends StatelessWidget {
  String mediaName;
  IconData icon;
  PlatformEntry({required this.mediaName, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.only(left: 20.0, right: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromARGB(255, 143, 172, 243),
        ),
        child: Row(
          children: [
            Icon(icon),
            Container(
                width: 175.0,
                height: 100.0,
                child: LineChart(LineChartData(
                  gridData: FlGridData(),
                ))),
            Column(
              children: [Text("Example")],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
