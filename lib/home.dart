import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool _isLoading= true;
  List<BarChartGroupData> dati = [];

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
      print(data);
      if(data['somma']==null){
        return 0;
      }else{
        return int.parse(data['somma']);
      }
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
      return int.parse(data["somma"]);
    }else{
      throw Exception(responseD['error']);
    }
  }

  Future<int> pezziAggiunti(String mese) async{
    http.Response response = await http.post(
        Uri.parse('http://188.12.130.133:1717/MeseAggiunti.php'),
        body: {
          'mese' : mese,
        });
    var responseD = jsonDecode(response.body);
    if(responseD['success']==true){
      var data = responseD['data'];
      return int.parse(data["somma"]);
    }else{
      throw Exception(responseD['error']);
    }
  }


  Future<void> getData() async {

    DateTime mese = DateTime.now();
    for(int i=0; i<4; i++){
      int meser = await getResiFromMounth(mese.month.toString());
      int mesei = await getImpegnatiFromMounth(mese.month.toString());
      dati.add(BarChartGroupData(x: mese.month, barRods: [
        BarChartRodData(fromY: 0, toY: meser.toDouble(), width: 15, color: Colors.blue),
        BarChartRodData(fromY: 0, toY: mesei.toDouble(), width: 15, color: Colors.green),
      ]));
      mese = DateTime(mese.year, mese.month-1, mese.day);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('MAGAZZINO',
            style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: _isLoading == true ? const Center(child: CircularProgressIndicator()) :
      Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top:10.0,bottom:10.0),
                child: BarChart(
                    BarChartData(
                        borderData: FlBorderData(
                        border: const Border(
                        top: BorderSide.none,
                          right: BorderSide.none,
                          left: BorderSide(width: 1),
                          bottom: BorderSide(width: 1),
                        )),
                        groupsSpace: 10,
                        barGroups: dati)),
              ),
    ),
            Text("data"),
          ],
        ),
      ),
    );
  }
}
