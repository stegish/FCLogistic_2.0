import 'package:flutter/material.dart';
import 'dart:io';
import 'package:excel/excel.dart';

class Carica extends StatefulWidget {
  const Carica({Key? key}) : super(key: key);

  @override
  State<Carica> createState() => _CaricaState();
}

class _CaricaState extends State<Carica> {

  static final GlobalKey<ScaffoldState> _Carica = GlobalKey<ScaffoldState>(); //key per i pop-up
  final input = [TextEditingController()]; //bancale
  List<String> risultato = [];

  void rimuoviDuplicati(List<String> risultatoo){
    for(int i=0; i<risultatoo.length; i++){
      for(int j=i+1; j<risultato.length;j++){
        if(risultato[i]==risultatoo[j]){
          risultato.removeAt(i);
        }
      }
    }
  }

  RealTimeSearch(){
    risultato.clear();
    if(input[0].text!=""){
      var file = File("assets/magazzino.xlsx");
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = "magazzino";
      Sheet a = excel[table];
      int rigaMax= a.maxRows;
      for (int i = 1; i < rigaMax+1&&risultato.length<20; i++) {
        String cella = "B$i";
        if (a.cell(CellIndex.indexByString(cella)).value.toString().contains(input[0].text)==true) {
          risultato.add(a.cell(CellIndex.indexByString(cella)).value.toString());
        }
        rimuoviDuplicati(risultato);
      }
    }
  }

  VaiCVMagazzino(){
    //Navigator.push(context, MaterialPageRoute(builder: (context) => CVMagazzino(bancale: input[0].text)),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _Carica,
      appBar: AppBar(
        title: const Center(
          child: Text("CARICA     ",
            style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(30.0),
              child :Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return risultato.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  debugPrint('You just selected $selection');
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: VaiCVMagazzino,
        tooltip: 'ricerca',
        child: const Icon(Icons.search),
      ),
    );
  }
}
