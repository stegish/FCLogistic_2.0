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
  final input = [TextEditingController()]; //bancale

  Future<List<String>> RealTimeSearch(String cod) async{
    List<String> risultato = [];
    var url = "http://188.12.130.133:1717/Trova.php";
    http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'codice': cod,
      },
    );
    var responseD = jsonDecode(response.body);
    print(responseD);
    if(responseD['success']==true){
      List<dynamic> data = responseD['data'];
      print(data);
      for(int i =0; i<data.length;++i) {
        risultato.add(data[i]['nomeBM']);
        print(data[i]['nomeBM']);
      }
    }
    return risultato;
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
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  List<String> ris = await RealTimeSearch(textEditingValue.text);
                  return ris;
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
