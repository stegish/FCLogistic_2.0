import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Impegna.dart';
import 'Resi.dart';
import 'DBancale.dart';
import 'DMag.dart';


class MagazzinoCompleto extends StatefulWidget {
  @override
  _MagazzinoCompletoState createState() => _MagazzinoCompletoState();
}

class _MagazzinoCompletoState extends State<MagazzinoCompleto> {
  final _scrollController = ScrollController();
  List<DBancale> _list = [];
  int _currentPage = 1;
  bool _isLoading = false;
  late String _error;
  int expanded = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _fetchData(_currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getContenutoBancale(String nomeB, String DataB) async {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    try {
      http.Response response = await http.post(
        Uri.parse('http://188.12.130.133:1717/contenutoBancale.php'),
        body: {
          'bancale': nomeB
        },
      );
      var responseD = jsonDecode(response.body);
      print(responseD);
      if (true == responseD['success']) {
        setState(() {
          List<dynamic> data = responseD['data'];
          print(data);
          List<int> codici=[];
          List<int> nPezzi=[];
          List<String> date=[];
          for(int i =0; i<data.length;++i) {
            codici.add(int.parse(data[i]["codicePM"]));
            nPezzi.add(int.parse(data[i]["quantitaM"]));
            date.add(data[i]["data_inserimentoM"]);
          }
          _list.add(DBancale(nomeB, DataB, codici, nPezzi, date));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _fetchData(int pageKey) async {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    try {
    final response = await http.post(Uri.parse('http://188.12.130.133:1717/magazzinoCompleto.php'));
    var responseD = jsonDecode(response.body);
    if (true == responseD['success']) {
      setState(() {
        List<dynamic> data = responseD['data'];
        print(data);
        for(int i =0; i<data.length;++i) {
          print(data[i]["nomeB"]);
          getContenutoBancale(data[i]["nomeB"], data[i]["data_creazioneB"]);
        }
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void VaiImpegna(DMag d){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Impegna(riga: d)),);
  }

  void VaiResi(DMag d){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Resi(riga: d)),);
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _currentPage++;
      _fetchData(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('MAGAZZINO',
            style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: _error != ""
          ? Center(child: Text('Error: $_error'),)
          : ListView.builder(
        controller: _scrollController,
        itemCount: _list.length + (_isLoading ? 1 : 0),
        itemBuilder: (BuildContext context, int i) {
          if (i == _list.length) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container(
              child: ExpansionTile(
                leading: CircleAvatar(child: Text("${_list[i].sommaCodici()}")),
                title: Text("BANCALE: ${_list[i].getBancale()}"),
                subtitle: Text("data creazione: ${_list[i].getData()}"),
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: _list[i].sommaCodici(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int j){
                          return Expanded(
                            child: Card(
                                  child: ExpansionTile(
                                    onExpansionChanged: (bool change) {
                                      setState(() {
                                        if(change){
                                          expanded ++;
                                          print(expanded);
                                        }else{
                                          expanded --;
                                        }
                                      });
                                    },
                                    leading: CircleAvatar(child: Text("${_list[i].getnPezziC()[j]}")),
                                    title: Text("codice: ${_list[i].getCodiciC()[j]}"),
                                    subtitle: Text("data: ${_list[i].getDateC()[j]}"),
                                    children: <Widget>[
                                      Expanded(
                                        child: ButtonBar(
                                          alignment: MainAxisAlignment.spaceAround,
                                          buttonHeight: 52.0,
                                          buttonMinWidth: 90.0,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextButton(
                                                style: flatButtonStyle,
                                                onPressed: () {
                                                  VaiImpegna(DMag(_list[i].getCodiciC()[j], _list[i].getBancale(),
                                                      _list[i].getnPezziC()[j], _list[i].getDateC()[j]));
                                                },
                                                child: const Column(
                                                  children: <Widget>[
                                                    Icon(Icons.arrow_downward),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                                    ),
                                                    Text('Impegna'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                style: flatButtonStyle,
                                                onPressed: () {
                                                  VaiResi(DMag(_list[i].getCodiciC()[j], _list[i].getBancale(),
                                                      _list[i].getnPezziC()[j], _list[i].getDateC()[j]));
                                                },
                                                child: const Column(
                                                  children: <Widget>[
                                                    Icon(Icons.arrow_upward),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                                    ),
                                                    Text('Reso'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                style: flatButtonStyle,
                                                onPressed: () {
                                                },
                                                child: const Column(
                                                  children: <Widget>[
                                                    Icon(Icons.swap_vert),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                                    ),
                                                    Text('Elimina'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
