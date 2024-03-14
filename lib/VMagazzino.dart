import 'package:flutter/material.dart';
//import 'package:untitled/SCMagazzino.dart';
import 'DMag.dart';

//visualizza i banccali trovati con il codice cercato tramite una ListView
class VMagazzino extends StatefulWidget {
  List<DMag> listaRisultati = []; //numero risultati dropdown

  VMagazzino({Key? key, required this.listaRisultati}) :super(key: key);

  @override
  State<VMagazzino> createState() => _VMagazzinoPageState(risultati: listaRisultati);
}
class _VMagazzinoPageState extends State<VMagazzino>{
  List<int> dropDownValue = []; //numero risultati dropdown
  List<DMag> risultati = []; //lista risultati
  _VMagazzinoPageState({Key? key, required this.risultati});

  void VaiImpegna(){

  }

  void VaiResi(){

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
                itemBuilder: (BuildContext context, int index){
                  return Card(
                    child:ExpansionTile(
                      leading: const CircleAvatar(child: Text('A')),
                      title: Text("codice: ${risultati[index].getCodice()}"),
                      subtitle: Text("data: ${risultati[index].getData()}"),
                      children: <Widget>[
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          buttonHeight: 52.0,
                          buttonMinWidth: 90.0,
                          children: <Widget>[
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                VaiImpegna();
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
                                VaiResi();
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
                          ],
                        ),
                      ],
                    )
                    );
                  /*
                  return Card(
                    elevation: 10.0,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.red),
                      child : ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                        title:Text(
                          "codice: ${risultati[index].getCodice()}\nagiunto il: ${risultati[index].getData()}\npezzi: ${risultati[index].getPezzi()}\nbancale: ${risultati[index].getBancale()}",
                          style: const TextStyle(fontWeight: FontWeight.bold),),
                        onTap: () =>[
                          vaiSSMagazzino(index),],
                        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 60),
                      ),
                    ),
                  );*/
                }
            ),
          )
      ),
    );
  }
}