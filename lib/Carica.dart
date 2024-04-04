import 'dart:convert';
import 'dart:io';

import 'package:fcmagazzino/snakBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Carica extends StatefulWidget {
  const Carica({Key? key}) : super(key: key);

  @override
  State<Carica> createState() => _CaricaState();
}

class _CaricaState extends State<Carica> {
  static final GlobalKey<ScaffoldState> _Carica =
      GlobalKey<ScaffoldState>(); //key per i pop-up
  final input = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ]; //bancale
  String bancale = "";
  bool nuovoBancale = false;
  String colonna = "";
  final _CaricaF = GlobalKey<FormState>(); //key del form1

  Future<List<String>> RealTimeSearch(String banc) async {
    List<String> risultato = [];
    var url = "http://188.12.130.133:1717/TrovaBancale.php";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {
          'bancale': banc,
        },
      );
      var responseD = jsonDecode(response.body);
      print(responseD);
      if (responseD['success'] == true) {
        List<dynamic> data = responseD['data'];
        print(data);
        for (int i = 0; i < data.length; ++i) {
          risultato.add(data[i]['nomeB']);
          colonna = data[0]['colonnaB'];
        }
      }
      return risultato;
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  void SendData() async {
    var url = "http://188.12.130.133:1717/Carica.php";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {
          'codice': input[0].text,
          'bancale': bancale,
          'quantita': input[1].text,
          'data':
              "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
          'descrizione': '',
          'colonna': input[3].text
        },
      );
      var responseD = jsonDecode(response.body);
      if (responseD['success'] == true) {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "dati inseriri con successo", "successo");
      } else {
        GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
            "errore inserimento dati", "fallito");
      }
    } on SocketException catch (_) {
      GlobalValues.showSnackbar(ScaffoldMessenger.of(context), "ATTENZIONE",
          "connessione assente", "attenzione");
      throw ("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _Carica,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "CARICA",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Form(
          key: _CaricaF,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        optionsBuilder: (textEditingValue) async {
                          List<String> ris =
                              await RealTimeSearch(textEditingValue.text);
                          bancale = textEditingValue.text;
                          if (ris[0] == textEditingValue.text) {
                            setState(() {
                              nuovoBancale = false;
                            });
                            input[3].text = colonna;
                          } else {
                            setState(() {
                              nuovoBancale = true;
                            });
                          }
                          return ris;
                        },
                        fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) {
                          return TextFormField(
                            validator: (val) => (val!.isEmpty ||
                                    val.contains('.') ||
                                    val.contains(',') ||
                                    val.contains('-') ||
                                    val.contains(' '))
                                ? "inserisci il nome"
                                : null,
                            controller: textEditingController,
                            focusNode: focusNode,
                            onEditingComplete: onFieldSubmitted,
                            decoration: const InputDecoration(
                              hintText: 'inserisci nome bancale',
                              labelText: 'bancale *',
                            ),
                          );
                        },
                        optionsViewBuilder: ((context, onSelected, ris) {
                          return Material(
                              child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            itemCount: ris.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(ris.elementAt(index)),
                              );
                            },
                          ));
                        }),
                        onSelected: (ris) => debugPrint(ris),
                        displayStringForOption: ((ris) => ris),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                          enabled: nuovoBancale,
                          keyboardType: TextInputType.number,
                          controller: input[3],
                          decoration: const InputDecoration(
                            hintText: 'colonna bancale',
                            labelText: 'colonna *',
                          ),
                          validator: (val) {
                            if (val!.isEmpty ||
                                val.contains(".") ||
                                val.contains(",") ||
                                int.parse(val) < 100) {
                              return "togli \". , -\" e spazi, max 2 cifre";
                            } else {
                              return null;
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: input[0],
                  decoration: const InputDecoration(
                    hintText: 'inserire il codice',
                    labelText: 'codice *',
                  ),
                  validator: (val) => (val!.isEmpty ||
                          val.contains('.') ||
                          val.length < 8 ||
                          val.contains(',') ||
                          val.contains('-') ||
                          val.contains(' '))
                      ? "togli \". , -\" e spazi, max 8 cifre"
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: input[1],
                    decoration: const InputDecoration(
                      hintText: 'inserire quantita',
                      labelText: 'quantita *',
                    ),
                    validator: (val) {
                      if (val!.isEmpty ||
                          val.contains('.') ||
                          int.parse(val) < 1000 ||
                          val.contains(',')) {
                        return "togli \". , -\" e spazi, max 4 cifre";
                      } else {
                        return null;
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          if (_CaricaF.currentState!.validate()) {
            SendData();
          } else {
            GlobalValues.showSnackbar(ScaffoldMessenger.of(context),
                "ATTENZIONE", "controllare valori inseiri", "attezione");
          }
        },
        tooltip: 'ricerca',
        child: const Icon(Icons.search),
      ),
    );
  }
}
