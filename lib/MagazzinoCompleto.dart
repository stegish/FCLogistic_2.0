import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DMag.dart';


class MagazzinoCompleto extends StatefulWidget {
  @override
  _MagazzinoCompletoState createState() => _MagazzinoCompletoState();
}

class _MagazzinoCompletoState extends State<MagazzinoCompleto> {
  final _scrollController = ScrollController();
  final _list = <DMag>[];
  int _currentPage = 1;
  bool _isLoading = false;
  late String _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _fetchData(_currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData(int pageKey) async {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    //try {
      final response = await http.post(Uri.parse('http://188.12.130.133:1717/magazzinoCompleto.php'));
      var responseD = jsonDecode(response.body);
      if (response == responseD) {
        setState(() {
          List<dynamic> data = responseD['data'];
          print(data);
          for(int i =0; i<data.length;++i) {
            _list.add(DMag(int.parse(data[i]['codicePM']), data[i]['nomeBM'],
                int.parse(data[i]['quantitaM']), data[i]['data_inserimentoM']));
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    /*} catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }*/
  }

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _currentPage++;
      _fetchData(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAGAZZINO'),
      ),
      body: _error != ""
          ? Center(child: Text('Error: $_error'))
          : ListView.builder(
        controller: _scrollController,
        itemCount: _list.length + (_isLoading ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == _list.length) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListTile(
              title: Text(_list[index].toString()),
            );
          }
        },
      ),
    );
  }
}
