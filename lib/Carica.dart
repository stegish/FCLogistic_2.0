import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Carica extends StatefulWidget {
  const Carica({Key? key}) : super(key: key);

  @override
  State<Carica> createState() => _CaricaState();
}

class _CaricaState extends State<Carica> {

  static final GlobalKey<ScaffoldState> _Carica = GlobalKey<ScaffoldState>(); //key per i pop-up
  final input = [TextEditingController(),  TextEditingController(),  TextEditingController()]; //bancale
  String bancale="";

  Future<List<String>> RealTimeSearch(String banc) async{
    List<String> risultato = [];
    var url = "http://188.12.130.133:1717/TrovaBancale.php";
    http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'bancale': banc,
      },
    );
    var responseD = jsonDecode(response.body);
    print(responseD);
    if(responseD['success']==true){
      List<dynamic> data = responseD['data'];
      print(data);
      for(int i =0; i<data.length;++i) {
        risultato.add(data[i]['nomeB']);
        print(data[i]['nomeB']);
      }
    }
    return risultato;
  }

  void SendData() async{
    if(bancale!="") {
      var url = "http://188.12.130.133:1717/Carica.php";
      http.Response response = await http.post(
        Uri.parse(url),
        body: {
          'codice': input[0].text,
          'bancale': bancale,
          'quantita': input[1].text,
          'data': "${DateTime
              .now()
              .year}-${DateTime
              .now()
              .month}-${DateTime
              .now()
              .day}",
          'descrizione': '',
        },
      );
      var responseD = jsonDecode(response.body);
      print(responseD);
      if (responseD['success'] == true) {
        print("successo");
        //TODO: aggiungere snackbar per successo
      } else {
        //TODO: aggiungere snackbar per l'errore
        print(responseD);
      }
    }else{
      print("sbagliato");
          //TODO: aggiungere snackbar per l'errore
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
              child : Autocomplete<String>(
                optionsBuilder: (textEditingValue) async {
                  List<String> ris = await RealTimeSearch(textEditingValue.text);
                  bancale=textEditingValue.text;
                  return ris;
                  },
                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted){
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onEditingComplete: onFieldSubmitted,
                      decoration: const InputDecoration(
                        hintText: 'inserisci nome bancale',
                        labelText: 'bancale *',
                      ),
                    );
                },
                optionsViewBuilder: ((context, onSelected, ris){
                  return Material(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical:20),
                      itemCount: ris.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(ris.elementAt(index)),
                        );
                      },
                    )
                  );
                }),
                onSelected: (ris) => debugPrint(ris),
                displayStringForOption: ((ris)=> ris),
              ),
            ),
            Padding(padding: EdgeInsets.all(30.0),
              child : TextFormField(
                keyboardType: TextInputType.number,
                controller: input[0],
                decoration: const InputDecoration(
                  hintText: 'inserire il codice',
                  labelText: 'codice *',
                ),
                validator: (val) => (val!.isEmpty||val.contains('.')||val.length!=8||val.contains(',')||val.contains('-')||val.contains(' ')) ? "togli \". , -\" e spazi, max 8 cifre" : null,
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
                  validator: (val){
                    if(val!.isEmpty || val.length>8){
                      return "inserisci quantita";
                    }else{
                      return null;
                    }}
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: SendData,
        tooltip: 'ricerca',
        child: const Icon(Icons.search),
      ),
    );
  }
}
