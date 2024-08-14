import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/katasifat_provider.dart';

class KataSifatScreen extends StatefulWidget {
  @override
  _KataSifatScreenState createState() => _KataSifatScreenState();
}

class _KataSifatScreenState extends State<KataSifatScreen> {
  final TextEditingController _searchController = TextEditingController();
  List _filteredKataSifatList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KataSifatProvider>(context, listen: false).fetchKataSifat().then((_) {
        setState(() {
          _filteredKataSifatList = Provider.of<KataSifatProvider>(context, listen: false).kataSifatList;
        });
      });
    });
  }

  void _filterKataSifat(String query) {
    final kataSifatProvider = Provider.of<KataSifatProvider>(context, listen: false);
    final filteredList = kataSifatProvider.kataSifatList.where((kataSifat) {
      return kataSifat.englishWord.toLowerCase().contains(query.toLowerCase()) ||
          kataSifat.indonesianWord.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredKataSifatList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kata Sifat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Cari Kata Sifat'),
              onChanged: (value) {
                _filterKataSifat(value);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredKataSifatList.length,
                itemBuilder: (context, index) {
                  final kataSifat = _filteredKataSifatList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(kataSifat.englishWord),
                      subtitle: Text(kataSifat.indonesianWord),
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
