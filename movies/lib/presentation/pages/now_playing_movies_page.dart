// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/now_playing/now_playing_movies_bloc.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';

import 'package:flutter/material.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  static const routeName = "/playing-movies";

  const NowPlayingMoviesPage({super.key});

  @override
  State<NowPlayingMoviesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<NowPlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies()),
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
        child: BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
          builder: (context, state) {
            if (state is NowPlayingMoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingMoviesHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is NowPlayingMoviesEmpty) {
              return const Center(
                child: Text("Empty data"),
              );
            } else if (state is NowPlayingMoviesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Container(),
              );
            }
          },
        ),
      ),
    );
  }
}
