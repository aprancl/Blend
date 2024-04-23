import 'package:blend/components/appBars/main_app_bar.dart';
import 'package:blend/components/misc/skewbox.dart';
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

  Color cssToColor(String color) {
    String hex = color.split('(')[1].split(')')[0];
    List<String> rgba = hex.split(',');
    return Color.fromRGBO(
      int.parse(rgba[0]),
      int.parse(rgba[1]),
      int.parse(rgba[2]),
      double.parse(rgba[3]),
    );
  }

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
          GestureDetector(
            onTap: () {
              provider.goToNavPage(2);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 0, 74, 178),
                      Color.fromARGB(255, 28, 105, 212),
                      Color.fromARGB(255, 0, 175, 218),
                    ],
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
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.5,
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
                                height: 20,
                              ),
                              Container(
                                height: 100.0,
                                child: Column(
                                  children: [
                                    Text(
                                      "\u2022 Instagram",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "\u2022 Youtube",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "\u2022 TikTok",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "\u2022 SnapChat",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
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
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/workspace/blendcard',
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 255, 132, 1),
                      Color.fromARGB(255, 255, 132, 1),
                      Color.fromARGB(255, 228, 188, 28),
                      Color.fromARGB(255, 228, 188, 28),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Title(
                        color: Color(0xFFFFFFFF),
                        child: Text(
                          "Blend Card",
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
                      SkewBox(
                        topColor: cssToColor(provider.blendCard.topColor!),
                        bottomColor:
                            cssToColor(provider.blendCard.bottomColor!),
                        height: (MediaQuery.of(context).size.width / 16) * 9,
                        width: MediaQuery.of(context).size.width,
                        image: provider.blendCard.background!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// this class contains all the data the user sets for the posting process
