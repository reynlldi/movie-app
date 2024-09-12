import 'package:movies/presentation/pages/movie_list_page.dart';
import 'package:tv_series/presentation/pages/tv_series_list_page.dart';

import '../../core.dart';
import 'about_page.dart';
import 'watchlist_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const MovieListPage(),
    const TvSeriesListPage(),
    const WatchlistPage(),
    const AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Tv Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kMikadoYellow,
        onTap: _onItemTapped,
        backgroundColor: kRichBlack,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
