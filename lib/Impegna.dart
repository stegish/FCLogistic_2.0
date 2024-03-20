import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DMag.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:input_quantity/input_quantity.dart';



class Impegna extends StatefulWidget {

  final DMag riga;

  Impegna({Key? key, required this.riga}): super(key: key);

  @override
  State<Impegna> createState() => _ImpegnaState(rigap: riga);
}

class _ImpegnaState extends State<Impegna> {
  final DMag rigap; //lista con i vari risultati trovati
  static final GlobalKey<ScaffoldState> _ImpegnaS = GlobalKey<ScaffoldState>(); //per la comparsa dei pop-up
  final input = [TextEditingController()]; //variabile per l'input
  final _ImpegnaF = GlobalKey<FormState>(); //key del form1
  int quantitaI=0;

  _ImpegnaState({required this.rigap});


  //cerca nel database il codice inserito
  void sendData(int quantitaI) async{
    var url = "http://188.12.130.133:1717/Impegna.php";
    print(rigap.getnPezzi());
    http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'codice': rigap.getCodice().toString(),
        'quantita' : rigap.getnPezzi().toString(),
        'quantitaI': quantitaI.toString(),
        'bancale' : rigap.getBancale().toString(),
        'data' : DateTime.now().year.toString() +"-"+DateTime.now().month.toString() +"-"+ DateTime.now().day.toString(),
        'commessa' : input[0].text
      },
    );
    var responseD = jsonDecode(response.body);
    print(responseD);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ImpegnaS,
      appBar: AppBar(
        title: const Center(
          child: Text("SCARICA",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Form(
        key: _ImpegnaF,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(30.0),
                child :InputQty.int(
                  maxVal: rigap.getnPezzi(),
                  initVal: 0,
                  minVal: 0,
                  steps: 1,
                  validator: (value) {
                    if (value == null) {
                      return "inserisci un valore";
                    } else if (value > rigap.getnPezzi()) {
                      return "stai cercando di togliere troppi pezzi";
                    } else if(value.runtimeType==double){
                      return "stai inserendo un vslore non concesso";
                    }
                    return null;
                  },
                  onQtyChanged: (val) {
                    quantitaI=val;
                  },
                  decoration: const QtyDecorationProps(
                    borderShape: BorderShapeBtn.circle, width: 25,
                    minusBtn: Icon(Icons.exposure_minus_1, color: Colors.red,
                    ),
                    plusBtn: Icon(Icons.plus_one, color: Colors.green),
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: input[0],
                validator: (val) => (val!.isEmpty||val.contains('.')||val.contains(',')||val.contains('-')||val.contains(' ')) ? "inserisci la commessa" : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.numbers),
                  hintText: 'SJ*****',
                  labelText: 'commessa *',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: (){
          if (_ImpegnaF.currentState!.validate()) {
            sendData(quantitaI);
          }
        },
        tooltip: 'ricerca',
        child: const Icon(Icons.search),
      ),
    );
  }
}
