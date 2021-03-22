import 'package:flutter/material.dart';
import 'stacked_history_chart.dart';
import 'stacked_history_chart_mock_data.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("KPI chart", style: TextStyle(color: Colors.grey, letterSpacing: 1.2),),
        ),
        body: _buildStackedHistoryChart(),
    );
  }

  Widget _buildStackedHistoryChart(){
    return Center(
      child: SizedBox(
        height: 100,
        child: StackedHistoryChart(
          data: StackedHistoryChartMockData.data,
          decoration: StackedHistoryChartMockData.decoration,
        ),
      ),
    );
  }
}



