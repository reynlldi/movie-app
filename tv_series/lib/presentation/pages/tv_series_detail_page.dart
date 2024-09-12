// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/presentation/widgets/shimmer_recommendation.dart';
import 'package:core/utils/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tv_series/presentation/bloc/detail/detail_tv_series_bloc.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = "/detail-tv-series";

  final int id;

  const TvSeriesDetailPage({super.key, required this.id});

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DetailTvSeriesBloc>().add(FetchDetailTvSeries(widget.id));
      context
          .read<DetailTvSeriesBloc>()
          .add(LoadWatchlistStatusTvSeries(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailTvSeriesBloc, DetailTvSeriesState>(
        builder: (context, state) {
          if (state.tvSeriesState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.tvSeriesState == RequestState.loaded) {
            final tvSeries = state.tvSeries;
            return SafeArea(
              child: DetailContentTvSeries(
                tvSeries!,
                state.tvSeriesRecommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state.tvSeriesState == RequestState.empty) {
            return const Center(
              child: Text("Empty data"),
            );
          } else if (state.tvSeriesState == RequestState.error) {
            return Center(
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

class DetailContentTvSeries extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlistTvSeries;

  const DetailContentTvSeries(
    this.tvSeries,
    this.recommendations,
    this.isAddedToWatchlistTvSeries, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvSeries.name,
                              style: kHeading5,
                            ),
                            BlocConsumer<DetailTvSeriesBloc,
                                DetailTvSeriesState>(
                              listenWhen: (previous, current) =>
                                  previous.watchlistMessage !=
                                      current.watchlistMessage &&
                                  current.watchlistMessage.isNotEmpty,
                              listener: (context, state) {
                                final message = state.watchlistMessage;
                                if (message ==
                                        DetailTvSeriesBloc
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        DetailTvSeriesBloc
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: Text(message),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(message),
                                      );
                                    },
                                  );
                                }
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () {
                                    if (!state.isAddedToWatchlist) {
                                      context
                                          .read<DetailTvSeriesBloc>()
                                          .add(AddWatchlistTvSeries(tvSeries));
                                    } else {
                                      context.read<DetailTvSeriesBloc>().add(
                                          RemoveWatchlistTvSeriess(tvSeries));
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      state.isAddedToWatchlist
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.add),
                                      const Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(
                              _showGenres(tvSeries.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSeries.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Language',
                              style: kHeading6,
                            ),
                            Text(
                              _showLanguage(tvSeries.languages),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'seasons',
                              style: kHeading6,
                            ),
                            SeasonList(
                              id: tvSeries.id,
                              seasons: tvSeries.seasons,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<DetailTvSeriesBloc,
                                DetailTvSeriesState>(
                              builder: (context, state) {
                                if (state.recommendationState ==
                                    RequestState.loading) {
                                  return const ShimmerRecommendations();
                                } else if (state.recommendationState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                detailTvSeriesRoute,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    SizedBox(
                                                  width: 100,
                                                  height: 150,
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.grey
                                                        .withOpacity(0.3),
                                                    highlightColor: Colors.grey
                                                        .withOpacity(0.1),
                                                    child: Container(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const SizedBox(
                                                  width: 100,
                                                  height: 150,
                                                  child: Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else if (state.recommendationState ==
                                    RequestState.empty) {
                                  return const Center(
                                    child: Text("Empty data"),
                                  );
                                } else if (state.recommendationState ==
                                    RequestState.error) {
                                  return Text(state.message);
                                } else {
                                  return Center(
                                    child: Container(),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showLanguage(List<String> languages) {
    if (languages.isEmpty) {
      return 'No languages available';
    }
    return languages.join(', ');
  }
}

class SeasonList extends StatelessWidget {
  final int id;
  final List<Season> seasons;

  const SeasonList({
    super.key,
    required this.id,
    required this.seasons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final season = seasons[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  detailSeasonRoute,
                  arguments: {
                    'id': season.id,
                    'seasonNumber': season.seasonNumber,
                  },
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/w500${season.posterPath}',
                  placeholder: (context, url) => SizedBox(
                    width: 100,
                    height: 150,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.3),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    width: 100,
                    height: 150,
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: seasons.length,
      ),
    );
  }
}
