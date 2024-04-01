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
  List<FlSpot> resi= [];
  List<FlSpot> impegnati = [];

  @override
  void initState() {
    super.initState();
    getData();
  }


  Future<int> getResiFromMounth(String mese) async {
    http.Response response = await http.post(
      Uri.parse('http://188.12.130.133:1717/MeseReso.php'),
    body: {
        'mese' : mese,
    });
    var responseD = jsonDecode(response.body);
    if(responseD['success']==true){
      var data = responseD['data'];
      return data.length;
    }else{
      throw Exception(responseD['error']);
    }
  }

  Future<int> getImpegnatiFromMounth(String mese) async {
    http.Response response = await http.post(
        Uri.parse('http://188.12.130.133:1717/MeseImpegnati.php'),
        body: {
          'mese' : mese,
        });
    var responseD = jsonDecode(response.body);
    if(responseD['success']==true){
      var data = responseD['data'];
      return data.length;
    }else{
      throw Exception(responseD['error']);
    }

  }


  Future<void> getData() async {
    DateTime mese = DateTime.now();
    for(int i=0; i<12; i++){
      int meser =  await getResiFromMounth(mese.month.toString());
      int mesei = await getResiFromMounth(mese.month.toString());
      resi.add(FlSpot(i.toDouble(), meser.toDouble()));
      impegnati.add(FlSpot(i.toDouble(), mesei.toDouble()));
      mese = DateTime(mese.year, mese.month-1, mese.day);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            lineBarsData: [
              // The red line
              LineChartBarData(
                spots: resi,
                isCurved: true,
                barWidth: 3,
                color: Colors.indigo,
              ),
              // The orange line
              LineChartBarData(
                spots: impegnati,
                isCurved: true,
                barWidth: 3,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
