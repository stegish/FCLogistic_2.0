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

  void VaiVMagazzino() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => VMagazzino(listaRisultati: risultato)),);
  }

  //cerca nel database il codice inserito
  Future<List<DMag>> getData() async{
    List<DMag> ris = [];
    var url = "http://188.12.130.133:1717/Trova.php";
    http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'codice': input[0].text,
      },
    );
    var responseD = jsonDecode(response.body);
    if(responseD==false){
      return ris;
    }else {
      List<dynamic> data = responseD['data'];
      print(data);
      for(int i =0; i<data.length;++i) {
        ris.add(DMag(int.parse(data[i]['codicePM']), data[i]['nomeBM'],
            int.parse(data[i]['quantitaM']), data[i]['data_inserimentoM']));
      }
      return ris;
    }
  }

  //esegue la funzione cerca e capisce se ha trovato risultati o no
  void avviaRicerca() async {
    risultato.clear();
    risultato = await getData();
    if (risultato.isEmpty) {
      GlobalValues.showSnackbar(
          _TrovaS , "ATTENZIONE", "codice non trovato", "fallito");
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
