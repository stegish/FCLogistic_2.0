import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DBancale.dart';
import 'DMag.dart';
import 'VMagazzino.dart';
import 'snakBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LineCharts.dart';



class Home extends StatefulWidget {
  const Home({super.key});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });


  Future<int> getResiFromMounth(String mese) async {
    http.Response response = await http.post(
      Uri.parse('http://188.12.130.133:1717/MeseReso.php'),
    body: {
        'data' : mese,
    });
    var responseD = jsonDecode(response.body);
    var data = responseD['data'];
    return data.length;
  }

  Future<int> getImpegnatiFromMounth(String mese) async {
    http.Response response = await http.post(
        Uri.parse('http://188.12.130.133:1717/MeseImpegnati.php'),
        body: {
          'data' : mese,
        });
    var responseD = jsonDecode(response.body);
    var data = responseD['data'];
    return data.length;
  }


  void getData(){
    for(int i=0; i<4; i++){

    }
    FlSpot()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // The red line
                LineChartBarData(
                  spots: dummyData1,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.indigo,
                ),
                // The orange line
                LineChartBarData(
                  spots: dummyData2,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.red,
                ),
                // The blue line
                LineChartBarData(
                  spots: dummyData3,
                  isCurved: false,
                  barWidth: 3,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
