import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:tv_series/presentation/pages/watchlist_tv_series_page.dart';

import 'package:flutter/material.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _titleTabOptions.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  final List<Widget> _titleTabOptions = <Widget>[
    const Text("Movies"),
    const Text("Tv Series"),
  ];

  final List<Widget> _widgetOptions = <Widget>[
    const WatchlistMoviesPage(),
    const WatchlistTvSeriesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchlist"),
        bottom: TabBar(
          controller: _tabController,
          tabs: _titleTabOptions,
          labelPadding: const EdgeInsets.all(8),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _widgetOptions,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
