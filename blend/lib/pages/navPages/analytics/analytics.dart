import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';

class AnalyticsPage extends StatelessWidget {
  // const AnalyticsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blend',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: MyAnalyticsPage(),
    );
  }
}

class MyAnalyticsPage extends StatefulWidget {
  @override
  State<MyAnalyticsPage> createState() => _MyAnalyticsPageState();
}

class _MyAnalyticsPageState extends State<MyAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 41, 255, 123)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        ],
      ),
    );
  }
}