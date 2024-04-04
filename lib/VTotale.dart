import 'dart:convert';
import 'dart:io';

import 'package:fcmagazzino/snakBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VTotale extends StatefulWidget {
  const VTotale({super.key});

  @override
  _VTotaleState createState() => _VTotaleState();
}

class _VTotaleState extends State<VTotale> {
  final _scrollController = ScrollController();
  List<Widget> _list = [];
  final input = [TextEditingController()]; //variabile per l'input
  bool _isLoading = false;
  String selected = "resi";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Widget>> getResi() async {
    List<Widget> ris = [];
    try {
      final response = await http
          .post(Uri.parse('http://188.12.130.133:1717/getResi.php'), body: {
        'input': input[0].text,
      });
      var responseD = jsonDecode(response.body);
      print(responseD);
      var data = responseD['data'];

      if (true == responseD['success']) {
        for (int i = 0; i < data.length; i++) {
          ris.add(Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.storage)),
              title: Text(
                "codice: ${data[i]['codicePR']}",
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text("bancale: ${data[i]['nomeBR']}"),
              trailing: Text("azienda: ${data[i]['nome_aziendaR']}"),
            ),
          ));
        }
        ris.toSet().toList();
        return ris;
      } else {
        ris.add(const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.storage)),
            title: Text("NESSUN RISULTATO TROVATO",
                style: TextStyle(fontSize: 14)),
            trailing: Icon(Icons.warning),
          ),
        ));
        return ris;
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<List<Widget>> getImpegnati() async {
    List<Widget> ris = [];
    try {
      final response = await http.post(
          Uri.parse('http://188.12.130.133:1717/getImpegnati.php'),
          body: {
            'input': input[0].text,
          });
      var responseD = jsonDecode(response.body);
      print(responseD);
      var data = responseD['data'];
      if (true == responseD['success']) {
        for (int i = 0; i < data.length; i++) {
          ris.add(Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.storage)),
              title: Text("codice: ${data[i]['codicePI']}",
                  style: TextStyle(fontSize: 14)),
              subtitle: Text("bancale: ${data[i]['nomeBI']}"),
              trailing: Text("commessa: ${data[i]['commessaI']}"),
            ),
          ));
        }
        ris.toSet().toList();
        return ris;
      } else {
        ris.add(const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.storage)),
            title: Text("NESSUN RISULTATO TROVATO",
                style: TextStyle(fontSize: 14)),
            trailing: Icon(Icons.warning),
          ),
        ));
        return ris;
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  Future<void> getData() async {
    List<Widget> ris = [];
    setState(() {
      _isLoading = true;
    });
    try {
      if (selected == "resi") {
        ris = await getResi();
      } else if (selected == "impegnati") {
        ris = await getImpegnati();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
      _list = ris;
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
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: input[0],
              decoration: const InputDecoration(
                icon: Icon(Icons.text_fields),
                hintText: 'inserire il codice o bancale',
                labelText: 'cerca',
              ),
              onChanged: (text) {
                getData();
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            buttonHeight: 52.0,
            buttonMinWidth: 90.0,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      selected == "impegnati" ? Colors.green : null,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selected = "impegnati";
                    getData();
                  });
                },
                child: const Column(
                  children: <Widget>[
                    Text('Impegnati'),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: selected == "resi" ? Colors.green : null,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selected = "resi";
                    getData();
                  });
                },
                child: const Column(
                  children: <Widget>[
                    Text('Reso'),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _list.length + (_isLoading ? 1 : 0),
              itemBuilder: (BuildContext context, int i) {
                if (i == _list.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return _list[i];
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
