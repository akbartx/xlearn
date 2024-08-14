import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KataBendaScreen extends StatefulWidget {
  @override
  _KataBendaScreenState createState() => _KataBendaScreenState();
}

class _KataBendaScreenState extends State<KataBendaScreen> {
  List<dynamic> kataBendaList = [];
  List<dynamic> filteredKataBendaList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchKataBenda();
    _searchController.addListener(_filterKataBenda);
  }

  Future<void> fetchKataBenda() async {
    final response = await http.get(Uri.parse('https://xlearn.initoko.com/api/kata_benda'));

    if (response.statusCode == 200) {
      setState(() {
        kataBendaList = json.decode(response.body);
        filteredKataBendaList = kataBendaList;
      });
    } else {
      throw Exception('Failed to load kata benda');
    }
  }

  void _filterKataBenda() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredKataBendaList = kataBendaList.where((kataBenda) {
        final englishWord = kataBenda['english_word'].toLowerCase();
        final indonesianWord = kataBenda['indonesian_word'].toLowerCase();
        return englishWord.contains(query) || indonesianWord.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kata Benda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Kata Benda',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredKataBendaList.length,
                itemBuilder: (context, index) {
                  final kataBenda = filteredKataBendaList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network(
                        'https://xlearn.initoko.com${kataBenda['image']}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(kataBenda['english_word']),
                      subtitle: Text(kataBenda['indonesian_word']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
