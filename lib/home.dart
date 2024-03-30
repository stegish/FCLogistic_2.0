import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DMag.dart';
import 'VMagazzino.dart';
import 'snakBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LineCharts.dart';



class Home extends StatefulWidget {
  const Home({super.key});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List<DMag> risultato = []; //lista con i vari risultati trovati
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
    if(responseD['success']==false){
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
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context),"ATTENZIONE", "codice non trovato", "fallito");
    } else {
      VaiVMagazzino();
    }
  }

  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              const Text(
                'Monthly Sales',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: LineCharts(isShowingMainData:  isShowingMainData),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}
