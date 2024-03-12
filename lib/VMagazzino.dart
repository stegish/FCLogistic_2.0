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

  void vaiSSMagazzino(int index) {
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SSMagazzino(file: file[index], cliente: cliente, commessa: commessa)),);
  }
  @override
  Widget build(BuildContext context) {
    const title = '          BANCALI';
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
            height: 1000,
            child: ListView.builder(
                itemCount: risultati.length,
                scrollDirection: Axis.vertical,
                prototypeItem: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListTile(
                    title: Text(risultati.first.getBancale()),
                  ),
                ),
                itemBuilder: (BuildContext context, int index){
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
                  );
                }
            ),
          )
      ),
    );
  }
}