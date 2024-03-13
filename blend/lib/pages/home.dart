import 'package:blend/components/appBars/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:pie_chart/pie_chart.dart' as pie;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataMap = <String, double>{
    "instagram": 543,
    "TikTok": 1000,
    "Youtube": 1221,
    "other": 900,
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    return Scaffold(
      appBar: MainAppBar().build(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(116, 50, 128, 246),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromARGB(116, 255, 255, 255),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // background color
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
                            legendPosition: pie.LegendPosition.bottom,
                          ),
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
                  ],
                ),
              ),
            ),
          ),

          Icon(
            Icons.home,
            size: 120,
            color: Colors.white,
          ),
          Text(
            'Home Page',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
          ),
          // button
          ElevatedButton(
            onPressed: () {
              provider.signOut();
            },
            child: Text('Sign Out'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/workspace/blendcard',
              );
            },
            child: Text('Blend Card'),
          )
        ],
      ),
    );
  }
}



// this class contains all the data the user sets for the posting process
