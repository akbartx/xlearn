import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/kosakata_provider.dart';
import '../models/kosakata.dart';

class KosakataScreen extends StatefulWidget {
  @override
  _KosakataScreenState createState() => _KosakataScreenState();
}

class _KosakataScreenState extends State<KosakataScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Kosakata> _filteredKosakataList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KosakataProvider>(context, listen: false).fetchKosakata().then((_) {
        setState(() {
          _filteredKosakataList = Provider.of<KosakataProvider>(context, listen: false).kosakataList;
        });
      });
    });
  }

  void _filterKosakata(String query) {
    final kosakataProvider = Provider.of<KosakataProvider>(context, listen: false);
    final filteredList = kosakataProvider.kosakataList.where((kosakata) {
      return kosakata.englishWordVerb1.toLowerCase().contains(query.toLowerCase()) ||
          kosakata.englishWordVerb2.toLowerCase().contains(query.toLowerCase()) ||
          kosakata.indonesianWord.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredKosakataList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kosakata'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Cari Kosakata'),
              onChanged: (value) {
                _filterKosakata(value);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<KosakataProvider>(
                builder: (context, kosakataProvider, child) {
                  if (kosakataProvider.kosakataList.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: _filteredKosakataList.length,
                    itemBuilder: (context, index) {
                      final kosakata = _filteredKosakataList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text('${kosakata.englishWordVerb1} - ${kosakata.englishWordVerb2}'),
                          subtitle: Text(kosakata.indonesianWord),
                        ),
                      );
                    },
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
