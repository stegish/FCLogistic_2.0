import 'dart:convert';
import 'dart:io';

import 'package:fcmagazzino/snakBar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;
  List<BarChartGroupData> dati = [];
  int perRimossiAggiunti = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<int> getResiFromDay() async {
    try {
      http.Response response = await http
          .post(Uri.parse('http://188.12.130.133:1717/GiornoResi.php'));
      var responseD = jsonDecode(response.body);
      if (responseD['success'] == true) {
        var data = responseD['data'];
        if (data[0]['somma'] == null) {
          return 0;
        } else {
          return int.parse(data[0]['somma']);
        }
      } else {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "problemi con i valori o connessione assente", "fallito");
        throw ("");
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<int> getResiFromMounth(String mese) async {
    try {
      http.Response response = await http
          .post(Uri.parse('http://188.12.130.133:1717/MeseReso.php'), body: {
        'mese': mese,
      });
      var responseD = jsonDecode(response.body);
      if (responseD['success'] == true) {
        var data = responseD['data'];
        if (data[0]['somma'] == null) {
          return 0;
        } else {
          return int.parse(data[0]['somma']);
        }
      } else {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "problemi con i valori o connessione assente", "fallito");
        throw ("");
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<int> getImpegnatiFromMDay() async {
    try {
      http.Response response = await http
          .post(Uri.parse('http://188.12.130.133:1717/GiornoImpegnati.php'));
      var responseD = jsonDecode(response.body);
      if (responseD['success'] == true) {
        var data = responseD['data'];
        print(data);
        if (data[0]['somma'] == null) {
          return 0;
        } else {
          return int.parse(data[0]['somma']);
        }
      } else {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "problemi con i valori o connessione assente", "fallito");
        throw ("");
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<int> getImpegnatiFromMounth(String mese) async {
    try {
      http.Response response = await http.post(
          Uri.parse('http://188.12.130.133:1717/MeseImpegnati.php'),
          body: {
            'mese': mese,
          });
      var responseD = jsonDecode(response.body);
      if (responseD['success'] == true) {
        var data = responseD['data'];
        print(data);
        if (data[0]['somma'] == null) {
          return 0;
        } else {
          return int.parse(data[0]['somma']);
        }
      } else {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "problemi con i valori o connessione assente", "fallito");
        throw ("");
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<int> getAggiuntiFromMonth(String mese) async {
    try {
      http.Response response = await http.post(
          Uri.parse('http://188.12.130.133:1717/MeseAggiunti.php'),
          body: {
            'mese': mese,
          });
      var responseD = jsonDecode(response.body);
      if (responseD['success'] == true) {
        var data = responseD['data'];
        if (data[0]['somma'] == null) {
          return 0;
        } else {
          return int.parse(data[0]['somma']);
        }
      } else {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "problemi con i valori o connessione assente", "fallito");
        throw ("");
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<int> getAggiuntiFromDay() async {
    try {
      http.Response response = await http
          .post(Uri.parse('http://188.12.130.133:1717/GiornoAggiunti.php'));
      var responseD = jsonDecode(response.body);
      if (responseD['success'] == true) {
        var data = responseD['data'];
        print(data);
        if (data[0]['somma'] == null) {
          return 0;
        } else {
          return int.parse(data[0]['somma']);
        }
      } else {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "problemi con i valori", "fallito");
        throw ("");
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<void> getData() async {
    DateTime mese = DateTime.now();
    for (int i = 0; i < 4; i++) {
      int meser = await getResiFromMounth(mese.month.toString());
      int mesei = await getImpegnatiFromMounth(mese.month.toString());
      int mesea = await getAggiuntiFromMonth(mese.month.toString());
      dati.add(BarChartGroupData(x: mese.month, barRods: [
        BarChartRodData(
            fromY: 0, toY: meser.toDouble(), width: 15, color: Colors.blue),
        BarChartRodData(
            fromY: 0, toY: mesei.toDouble(), width: 15, color: Colors.green),
        BarChartRodData(
            fromY: 0, toY: mesea.toDouble(), width: 15, color: Colors.red),
      ]));
      mese = DateTime(mese.year, mese.month - 1, mese.day);
    }
    perRimossiAggiunti = await getAggiuntiFromDay() -
        await getResiFromDay() -
        await getImpegnatiFromMDay();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('MAGAZZINO',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: _isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "AGGIUNTI",
                    style: TextStyle(color: Colors.red),
                  ),
                  const Text(
                    "IMPEGNATI",
                    style: TextStyle(color: Colors.green),
                  ),
                  const Text(
                    "RESI",
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: BarChart(BarChartData(
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
                  const Text("fino a 4 mesi indietro"),
                  Text(
                    "entrate - uscite ultimi 30 giorni : ${perRimossiAggiunti}",
                    style: perRimossiAggiunti > 0
                        ? TextStyle(color: Colors.red)
                        : TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
    );
  }
}
