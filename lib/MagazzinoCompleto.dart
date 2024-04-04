import 'dart:convert';
import 'dart:io';

import 'package:fcmagazzino/snakBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'DBancale.dart';
import 'DMag.dart';
import 'Impegna.dart';
import 'Resi.dart';

class MagazzinoCompleto extends StatefulWidget {
  @override
  _MagazzinoCompletoState createState() => _MagazzinoCompletoState();
}

class _MagazzinoCompletoState extends State<MagazzinoCompleto> {
  final _scrollController = ScrollController();
  List<DBancale> _list = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData("");
  }

  Future<void> getContenutoBancale(String nomeB, String DataB) async {
    setState(() {
      _isLoading = true;
    });
    try {
      http.Response response = await http.post(
        Uri.parse('http://188.12.130.133:1717/contenutoBancale.php'),
        body: {'bancale': nomeB},
      );
      var responseD = jsonDecode(response.body);
      print(responseD);
      if (true == responseD['success']) {
        setState(() {
          List<dynamic> data = responseD['data'];
          print(data);
          List<int> codici = [];
          List<int> nPezzi = [];
          List<String> date = [];
          for (int i = 0; i < data.length; ++i) {
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
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<void> _fetchData(String bancale) async {
    setState(() {
      _isLoading = true;
    });
    _list.clear();
    try {
      final response = await http.post(
          Uri.parse('http://188.12.130.133:1717/magazzinoCompleto.php'),
          body: {
            "bancale": bancale,
          });
      var responseD = jsonDecode(response.body);
      if (true == responseD['success']) {
        setState(() {
          List<dynamic> data = responseD['data'];
          print(data);
          for (int i = 0; i < data.length; ++i) {
            print(data[i]["nomeB"]);
            getContenutoBancale(data[i]["nomeB"], data[i]["data_creazioneB"]);
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  void VaiImpegna(DMag d) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Impegna(riga: d)),
    );
  }

  void VaiResi(DMag d) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Resi(riga: d)),
    );
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('MAGAZZINO',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: Icon(Icons.text_fields),
                hintText: 'inserire il codice o bancale',
                labelText: 'cerca',
              ),
              onChanged: (text) {
                setState(() {
                  _fetchData(text);
                });
              },
            ),
          ),
          Expanded(
            child: _list.length == 0 && _isLoading == false
                ? const Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(Icons.storage)),
                      title: Text("NESSUN RISULTATO TROVATO",
                          style: TextStyle(fontSize: 14)),
                      trailing: Icon(Icons.warning),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _list.length + (_isLoading ? 1 : 0),
                    itemBuilder: (BuildContext context, int i) {
                      if (i == _list.length) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                          child: ExpansionTile(
                            leading: CircleAvatar(
                                child: Text("${_list[i].sommaCodici()}")),
                            title: Text("BANCALE: ${_list[i].getBancale()}"),
                            subtitle:
                                Text("data creazione: ${_list[i].getData()}"),
                            children: <Widget>[
                              Container(
                                height: _list[i].sommaCodici() * 80,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _list[i].sommaCodici(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (BuildContext context, int j) {
                                      return Card(
                                        child: Expanded(
                                          child: ExpansionTile(
                                            onExpansionChanged:
                                                (bool change) {},
                                            leading: CircleAvatar(
                                                child: Text(
                                                    "${_list[i].getnPezziC()[j]}")),
                                            title: Text(
                                                "codice: ${_list[i].getCodiciC()[j]}"),
                                            subtitle: Text(
                                                "data: ${_list[i].getDateC()[j]}"),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
