import 'package:flutter/material.dart';

import 'DMag.dart';
import 'Impegna.dart';
import 'Resi.dart';

//visualizza i banccali trovati con il codice cercato tramite una ListView
class VMagazzino extends StatefulWidget {
  List<DMag> listaRisultati = []; //numero risultati dropdown
  VMagazzino({Key? key, required this.listaRisultati}) : super(key: key);

  @override
  State<VMagazzino> createState() =>
      _VMagazzinoPageState(risultati: listaRisultati);
}

class _VMagazzinoPageState extends State<VMagazzino> {
  List<int> dropDownValue = []; //numero risultati dropdown
  List<DMag> risultati = []; //lista risultati
  _VMagazzinoPageState({Key? key, required this.risultati});

  void VaiImpegna(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScaffoldMessenger(child: Impegna(riga: risultati[index]))),
    );
  }

  void VaiResi(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScaffoldMessenger(child: Resi(riga: risultati[index]))),
    );
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    const title = 'BANCALI';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        fontFamily: 'Arial',
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: Container(
            child: ListView.builder(
                itemCount: risultati.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ExpansionTile(
                    leading: CircleAvatar(
                        child: Text("${risultati[index].getnPezzi()}")),
                    title: Text("codice: ${risultati[index].getCodice()}"),
                    subtitle: Text("data: ${risultati[index].getData()}"),
                    trailing: Text("colonna: ${risultati[index].getColonna()}"),
                    children: <Widget>[
                      Text('bancale: ${risultati[index].getBancale()}'),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        buttonHeight: 52.0,
                        buttonMinWidth: 90.0,
                        children: <Widget>[
                          TextButton(
                            style: flatButtonStyle,
                            onPressed: () {
                              VaiImpegna(index);
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
                          TextButton(
                            style: flatButtonStyle,
                            onPressed: () {
                              VaiResi(index);
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
                          TextButton(
                            style: flatButtonStyle,
                            onPressed: () {},
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
                        ],
                      ),
                    ],
                  ));
                }),
          )),
    );
  }
}
