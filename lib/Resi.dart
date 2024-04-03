import 'dart:io';

import 'package:fcmagazzino/snakBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DMag.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:input_quantity/input_quantity.dart';

class Resi extends StatefulWidget {
  final DMag riga;

  Resi({Key? key, required this.riga}) : super(key: key);

  @override
  State<Resi> createState() => _ResiState(rigap: riga);
}

class _ResiState extends State<Resi> {
  final DMag rigap; //lista con i vari risultati trovati
  static final GlobalKey<ScaffoldState> _ResiS =
      GlobalKey<ScaffoldState>(); //per la comparsa dei pop-up
  final input = [TextEditingController()]; //variabile per l'input
  final _ResiF = GlobalKey<FormState>(); //key del form1
  int quantitaI = 0;

  _ResiState({required this.rigap});

  //cerca nel database il codice inserito
  void sendData(int quantitaI) async {
    var url = "http://188.12.130.133:1717/Resi.php";
    print(rigap.getnPezzi());
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {
          'codice': rigap.getCodice().toString(),
          'quantita': rigap.getnPezzi().toString(),
          'quantitaI': quantitaI.toString(),
          'bancale': rigap.getBancale().toString(),
          'data':
              "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
          'azienda': input[0].text
        },
      );
      var responseD = jsonDecode(response.body);
      if (responseD['success'] == false) {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "impossibile inserire i dati", "fallito");
      } else {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "dati inseriti correttamente", "successo");
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ResiS,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "RESO",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Form(
        key: _ResiF,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: InputQty.int(
                  maxVal: rigap.getnPezzi(),
                  initVal: 0,
                  minVal: 0,
                  steps: 1,
                  validator: (value) {
                    if (value == null) {
                      return "inserisci un valore";
                    } else if (value > rigap.getnPezzi()) {
                      return "stai cercando di togliere troppi pezzi";
                    } else if (value.runtimeType == double) {
                      return "stai inserendo un vslore non concesso";
                    }
                    return null;
                  },
                  onQtyChanged: (val) {
                    quantitaI = val;
                  },
                  decoration: const QtyDecorationProps(
                    borderShape: BorderShapeBtn.circle,
                    width: 25,
                    minusBtn: Icon(
                      Icons.exposure_minus_1,
                      color: Colors.red,
                    ),
                    plusBtn: Icon(Icons.plus_one, color: Colors.green),
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: input[0],
                validator: (val) => (val!.isEmpty ||
                        val.contains('.') ||
                        val.contains(',') ||
                        val.contains('-'))
                    ? "inserisci l'azienda a cui fare il reso"
                    : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.numbers),
                  hintText: 'Spa**',
                  labelText: 'azienda *',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          if (_ResiF.currentState!.validate()) {
            sendData(quantitaI);
          }
        },
        tooltip: 'ricerca',
        child: const Icon(Icons.search),
      ),
    );
  }
}
