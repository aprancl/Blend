import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:blend/components/appBars/main_app_bar.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final dataMap = <String, double>{
    "instagram": 543,
    "TikTok": 1000,
    "LinkedIn": 43,
    "Youtube": 1221,
    "snapchat": 900,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar().build(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Column(
                  children: [
                    Text("Hello world"),
                    PieChart(
                      dataMap: dataMap,
                      chartType: ChartType.ring,
                      chartRadius: MediaQuery.of(context).size.width / 2.5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Title(
                      color: Color(0xFFFFFFFF),
                      child: Text(
                        "Choose Platforms",
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
