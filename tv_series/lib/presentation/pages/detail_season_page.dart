// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/episode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/season/detail_season_bloc.dart';

class DetailSeasonPage extends StatefulWidget {
  static const routeName = "/detail-season";

  final int id;
  final int seasonNumber;

  const DetailSeasonPage({
    super.key,
    required this.id,
    required this.seasonNumber,
  });

  @override
  State<DetailSeasonPage> createState() => _DetailSeasonPageState();
}

class _DetailSeasonPageState extends State<DetailSeasonPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<DetailSeasonBloc>().add(FetchSeasonDetail(
            widget.id,
            widget.seasonNumber,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: BlocBuilder<DetailSeasonBloc, DetailSeasonState>(
          builder: (context, state) {
            if (state is DetailSeasonHasData) {
              final season = state.result;
              return Text(
                  season.name.isNotEmpty ? season.name : "Empty Season");
            } else {
              return const Text("Empty Season");
            }
          },
        ),
      ),
      body: BlocBuilder<DetailSeasonBloc, DetailSeasonState>(
        builder: (context, state) {
          if (state is DetailSeasonLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailSeasonHasData) {
            final episode = state.result.episodes;
            if (episode.isNotEmpty) {
              return ListView.builder(
                itemCount: episode.length,
                itemBuilder: (context, index) {
                  final episodes = episode[index];
                  return EpisodeCard(episodes);
                },
              );
            } else {
              return const Center(
                child: Text("No episodes available."),
              );
            }
          } else if (state is DetailSeasonEmpty) {
            return const Center(
              child: Text("Empty data"),
            );
          } else if (state is DetailSeasonError) {
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
    );
  }
}

class EpisodeCard extends StatelessWidget {
  final Episode episode;

  const EpisodeCard(this.episode, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Card(
            child: Container(
              margin: const EdgeInsets.only(
                left: 16 + 80 + 16,
                bottom: 8,
                right: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: kHeading6,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    episode.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              bottom: 16,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: episode.stillPath != null
                    ? '$baseImageUrl${episode.stillPath}'
                    : 'https://artsmidnorthcoast.com/wp-content/uploads/2014/05/no-image-available-icon-6.png',
                width: 80,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
