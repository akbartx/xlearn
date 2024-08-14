import 'package:flutter/material.dart';

import 'kata_benda_screen.dart';
import 'kata_pengganti_screen.dart';
import 'katasifat_screen.dart';
import 'kosakata_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xlearn'),
      ),
      body: Column(
        children: [
          _buildBannerCard(),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                _buildCategoryCard(context, 'Kosakata', Icons.book, Colors.blue, KosakataScreen()),
                _buildCategoryCard(context, 'Kata Sifat', Icons.color_lens, Colors.red, KataSifatScreen()),
                _buildCategoryCard(context, 'Kata Benda', Icons.chair, Colors.green, KataBendaScreen()),
                _buildCategoryCard(context, 'Kata Pengganti', Icons.swap_horiz, Colors.purple, KataPenggantiScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard() {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 150, // Anda bisa mengatur tinggi sesuai kebutuhan
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/images/banner.png'), // Pastikan gambar ada di folder assets
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color, Widget? destination) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: destination != null
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50, color: color),
            SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
