// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/presentation/widgets/shimmer_recommendation.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/presentation/bloc/detail/detail_movies_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail-movies';

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DetailMoviesBloc>().add(FetchDetailMovies(widget.id));
      context
          .read<DetailMoviesBloc>()
          .add(LoadWatchlistStatusMovies(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailMoviesBloc, DetailMoviesState>(
        builder: (context, state) {
          if (state.movieState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.movieState == RequestState.loaded) {
            final movie = state.movie;
            return SafeArea(
              child: DetailContent(
                movie!,
                state.movieRecommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state.movieState == RequestState.empty) {
            return const Center(
              child: Text("Empty data"),
            );
          } else if (state.movieState == RequestState.error) {
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

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(
    this.movie,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                              movie.title,
                              style: kHeading5,
                            ),
                            BlocConsumer<DetailMoviesBloc, DetailMoviesState>(
                              listenWhen: (previous, current) =>
                                  previous.watchlistMessage !=
                                      current.watchlistMessage &&
                                  current.watchlistMessage.isNotEmpty,
                              listener: (context, state) {
                                final message = state.watchlistMessage;
                                if (message ==
                                        DetailMoviesBloc
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        DetailMoviesBloc
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
                                  key: const Key('watchlist_button'),
                                  onPressed: () {
                                    if (!state.isAddedToWatchlist) {
                                      context
                                          .read<DetailMoviesBloc>()
                                          .add(AddWatchlistMovies(movie));
                                    } else {
                                      context
                                          .read<DetailMoviesBloc>()
                                          .add(RemoveWatchlistMovies(movie));
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
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<DetailMoviesBloc, DetailMoviesState>(
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
                                                detailMoviesRoute,
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
              key: const Key('icon_back'),
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
