import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/katasifat.dart';

class KataSifatProvider with ChangeNotifier {
  List<KataSifat> _kataSifatList = [];

  List<KataSifat> get kataSifatList => _kataSifatList;

  Future<void> fetchKataSifat() async {
    final response = await http.get(Uri.parse('https://xlearn.initoko.com/api/kata_sifat'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _kataSifatList = data.map((item) => KataSifat.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load kata sifat');
    }
  }
}
