import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/kosakata.dart';

class KosakataProvider with ChangeNotifier {
  List<Kosakata> _kosakataList = [];

  List<Kosakata> get kosakataList => _kosakataList;

  Future<void> fetchKosakata() async {
    final response = await http.get(Uri.parse('https://xlearn.initoko.com/api/kosakata'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _kosakataList = data.map((item) => Kosakata.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load kosakata');
    }
  }
}
