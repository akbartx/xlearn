import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchLeaderboard() async {
    final response = await http.get(Uri.parse('https://xlearn.initoko.com/api/leaderboard'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Data fetched from API: $data'); // Tambahkan log ini
      return List<Map<String, dynamic>>.from(data);
    } else {
      print('Failed to load leaderboard with status code: ${response.statusCode}'); // Tambahkan log ini
      throw Exception('Failed to load leaderboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final entry = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(entry['nama']),
                    subtitle: Text('Score: ${entry['score']}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
