import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DMag.dart';
import 'VMagazzino.dart';
import 'snakBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Trova extends StatefulWidget {
  const Trova({super.key});

  @override
  State<Trova> createState() => _TrovaState();
}

class _TrovaState extends State<Trova> {
  List<DMag> risultato = []; //lista con i vari risultati trovati
  static final GlobalKey<ScaffoldState> _TrovaS = GlobalKey<ScaffoldState>(); //per la comparsa dei pop-up
  final input = [TextEditingController(), TextEditingController()]; //variabile per l'input
  bool isChecked = false; //controlla se è un reso o no
  final _TrovaF = GlobalKey<FormState>(); //key del form1


  //cerca nel foglio excell il codice immesso in inpput[0] e salva ogni ccorrispondenza su risultato tramite il formato DMag
  /*Future<List<DMag>> Cerca() async {
    String codice = "";
    List<DMag> ris = [];
    if(input[0]!="") {
      codice = input[0].text;
      var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = "magazzino";
      Sheet a = excel[table];
      int rigaMax = excel.tables[table]!.maxRows+1;
      for (int i = 1; i < rigaMax; i++) {
        String cella = "C$i";
        if (a.cell(CellIndex.indexByString(cella)).value.toString() == codice) {
          String Ipezzi = "D$i";
          var pezzi = a.cell(CellIndex.indexByString(Ipezzi));
          String Ibancale = "B$i";
          var bancale = a.cell(CellIndex.indexByString(Ibancale));
          var data = a.cell(CellIndex.indexByString("E$i"));
          ris.add(DMag(int.parse(pezzi.value.toString()), i, bancale.value.toString(), int.parse(codice), data.toString()));
        }
      }
    }
    return ris;
  }*/

  void VaiVMagazzino() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => VMagazzino(listaRisultati: risultato)),);
  }

  //cerca nel database il codice inserito
  Future<List<DMag>> getData() async{
    List<DMag> ris = [];
    var url = "http://188.12.130.133:1717/Trova.php";
    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        'codice': input[0].text,
      }),
    );
    var responseD = jsonDecode(response.body);
    if(responseD==false){
      return ris;
    }else {
      Map<String, dynamic> data = responseD;
      print(data);
      for(int i =0; i<data.length;++i) {
        ris.add(DMag(int.parse(data['codicePM']), data['nomeBM'],
            int.parse(data['quantitaM']), data['data_inserimentoM']));
      }
      return ris;
    }
  }

  //esegue la funzione cerca e capisce se ha trovato risultati o no
  void avviaRicerca() async {
    risultato = await getData();
    if (risultato.isEmpty) {
      GlobalValues.showSnackbar(
          _TrovaS, "ATTENZIONE", "codice non trovato", "fallito");
    } else {
      VaiVMagazzino();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _TrovaS,
        appBar: AppBar(
          title: const Center(
            child: Text("SCARICA",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Form(
          key: _TrovaF,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.all(30.0),
                  child :TextFormField(
                    keyboardType: TextInputType.number,
                    controller: input[0],
                    validator: (val) => (val!.isEmpty||val.contains('.')||val.contains(',')||val.contains('-')||val.contains(' ')) ? "inserisci il codice" : null,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.numbers),
                      hintText: 'inserire il codice',
                      labelText: 'codice *',
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(30.0),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: (){
            if (_TrovaF.currentState!.validate()) {
              avviaRicerca();
            }
          },
          tooltip: 'ricerca',
          child: const Icon(Icons.search),
        ),
    );
  }
}
