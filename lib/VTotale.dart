import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Impegna.dart';
import 'Resi.dart';
import 'DBancale.dart';
import 'DMag.dart';


class VTotale extends StatefulWidget {
  const VTotale({super.key});

  @override
  _VTotaleState createState() => _VTotaleState();
}

class _VTotaleState extends State<VTotale> {
  final _scrollController = ScrollController();
  List<Widget> _list = [];
  final input = [TextEditingController()]; //variabile per l'input
  int _currentPage = 1;
  bool _isLoading = false;
  String selected="resi";
  late String _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    getData(_currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Widget>> getResi(int pageKey) async {
    List<Widget> ris =[];

    final response = await http.post(
        Uri.parse('http://188.12.130.133:1717/getResi.php'),
        body: {
          'input' : input[0].text,
        });
    var responseD = jsonDecode(response.body);
    print(responseD);
    var data = responseD['data'];
    if (true == responseD['success']) {
      for(int i =0; i<data.length;i++){
        ris.add(Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.storage)),
            title: Text("codice: ${data[i]['codicePR']}"),
            subtitle: Text("bancale: ${data[i]['nomeBR']}"),
            trailing: Text("azienda: ${data[i]['nome_aziendaR']}"),
          ),
        ));
      }
      return ris;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Widget>> getImpegnati(int pageKey) async {
    List<Widget> ris =[];

    final response = await http.post(
        Uri.parse('http://188.12.130.133:1717/getImpegnati.php'),
        body: {
          'input' : input[0].text,
        });
    var responseD = jsonDecode(response.body);
    print(responseD);
    var data = responseD['data'];
    if (true == responseD['success']) {
      for(int i =0; i<data.length;i++){
        ris.add(Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.storage)),
            title: Text("codice: ${data[i]['codicePI']}"),
            subtitle: Text("bancale: ${data[i]['nomeBI']}"),
            trailing: Text("commessa: ${data[i]['commessaI']}"),
          ),
        ));
      }
      return ris;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getData(int page) async {
    int page=0;
    List<Widget> ris = [];
    setState(() {
      _isLoading = true;
      _error = "";
    });
    try {
      if(selected=="resi"){
        ris= await getResi(page);
      }else if(selected=="impegnati"){
        ris= await getImpegnati(page);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
    setState(() {
      _isLoading = false;
      _list= ris;
    });
  }

  void VaiImpegna(DMag d){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Impegna(riga: d)),);
  }

  void VaiResi(DMag d){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Resi(riga: d)),);
  }

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _currentPage++;
      getData(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('MAGAZZINO',
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
                      getData(_currentPage);
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
                    backgroundColor: selected=="impegnati" ? Colors.green : null,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selected="impegnati";
                        getData(_currentPage);
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
                      backgroundColor: selected=="resi" ? Colors.green : null,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selected="resi";
                        getData(_currentPage);
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
