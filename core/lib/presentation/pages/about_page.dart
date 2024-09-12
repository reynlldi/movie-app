import 'package:flutter/material.dart';

import '../../core.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/circle-g.png',
                width: 128,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              child: const Text(
                'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
                style: TextStyle(
                  fontSize: 16,
                  color: kMikadoYellow,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
