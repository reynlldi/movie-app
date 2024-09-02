import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movies/now_playing_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  static const routeName = "/playing-movie";

  const NowPlayingMoviesPage({super.key});

  @override
  State<NowPlayingMoviesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<NowPlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<NowPlayingMovieNotifier>(context, listen: false)
          .fetchPlayingNowTvSeries(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NowPlayingMovieNotifier>(
          builder: (context, data, child) {
            if (data.nowPlayingState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.nowPlayingState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.nowPlayingMovie[index];
                  return MovieCard(tvSeries);
                },
                itemCount: data.nowPlayingMovie.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
