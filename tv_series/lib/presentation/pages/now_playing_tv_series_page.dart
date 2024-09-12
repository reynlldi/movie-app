// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing/now_playing_tv_series_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_series_card_list.dart';

class NowPlayingTvSeriesPage extends StatefulWidget {
  static const routeName = "/playing-tv-series";

  const NowPlayingTvSeriesPage({super.key});

  @override
  State<NowPlayingTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<NowPlayingTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          context.read<NowPlayingTvSeriesBloc>().add(FetchNowPlayingTvSeries()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
          builder: (context, state) {
            if (state is NowPlayingTvSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingTvSeriesHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = result[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: result.length,
              );
            } else if (state is NowPlayingTvSeriesEmpty) {
              return const Center(
                child: Text("Empty data"),
              );
            } else if (state is NowPlayingTvSeriesError) {
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
