import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:blend/components/appBars/main_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sfc;

class PlatformAnalyticsPage extends StatefulWidget {
  @override
  State<PlatformAnalyticsPage> createState() => _PlatformAnalyticsPageState();
}

class _PlatformAnalyticsPageState extends State<PlatformAnalyticsPage> {
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
                        width: 150.0,
                        height: 100.0,
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
