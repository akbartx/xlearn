import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KataPenggantiScreen extends StatefulWidget {
  @override
  _KataPenggantiScreenState createState() => _KataPenggantiScreenState();
}

class _KataPenggantiScreenState extends State<KataPenggantiScreen> {
  List<dynamic> kataPenggantiList = [];
  List<dynamic> filteredKataPenggantiList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchKataPengganti();
    _searchController.addListener(_filterKataPengganti);
  }

  Future<void> fetchKataPengganti() async {
    final response = await http.get(Uri.parse('https://xlearn.initoko.com/api/kata_pengganti'));

    if (response.statusCode == 200) {
      setState(() {
        kataPenggantiList = json.decode(response.body);
        filteredKataPenggantiList = kataPenggantiList;
      });
    } else {
      throw Exception('Failed to load kata pengganti');
    }
  }

  void _filterKataPengganti() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredKataPenggantiList = kataPenggantiList.where((kataPengganti) {
        final englishWord = kataPengganti['english_word'].toLowerCase();
        final indonesianWord = kataPengganti['indonesian_word'].toLowerCase();
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
        title: Text('Kata Pengganti'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Kata Pengganti',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredKataPenggantiList.length,
                itemBuilder: (context, index) {
                  final kataPengganti = filteredKataPenggantiList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(kataPengganti['english_word']),
                      subtitle: Text(kataPengganti['indonesian_word']),
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
