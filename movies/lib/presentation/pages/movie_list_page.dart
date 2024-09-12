// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/widgets/shimmer_carousel.dart';
import 'package:core/presentation/widgets/shimmer_home.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/now_playing/now_playing_movies_bloc.dart';
import 'package:movies/presentation/bloc/popular/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/up_coming/up_coming_movies_bloc.dart';
import 'package:movies/presentation/widgets/movie_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UpComingMoviesBloc>().add(FetchUpComingMovies());
      context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());
      context.read<PopularMoviesBloc>().add(FetchPopularMovies());
      context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchMoviesRoute);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming',
                style: kHeading6,
              ),
              BlocBuilder<UpComingMoviesBloc, UpComingMoviesState>(
                builder: (context, state) {
                  if (state is UpComingMoviesLoading) {
                    return const ShimmerCarousel();
                  } else if (state is UpComingMoviesHasData) {
                    return MovieCarousel(state.result);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () =>
                    Navigator.pushNamed(context, nowPlayingMoviesRoute),
              ),
              BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                builder: (context, state) {
                  if (state is NowPlayingMoviesLoading) {
                    return const ShimmerHome();
                  } else if (state is NowPlayingMoviesHasData) {
                    return MovieList(state.result);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, popularMoviesRoute),
              ),
              BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                builder: (context, state) {
                  if (state is PopularMoviesLoading) {
                    return const ShimmerHome();
                  } else if (state is PopularMoviesHasData) {
                    return MovieList(state.result);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(context, topRatedMoviesRoute),
              ),
              BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                builder: (context, state) {
                  if (state is TopRatedMoviesLoading) {
                    return const ShimmerHome();
                  } else if (state is TopRatedMoviesHasData) {
                    return MovieList(state.result);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            width: 150,
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: const Key('movies_item'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  detailMoviesRoute,
                  arguments: movie.id,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: '$baseImageUrl${movie.posterPath}',
                      errorWidget: (context, url, error) => const SizedBox(
                        width: 150,
                        height: 270,
                        child: Icon(Icons.error),
                      ),
                      placeholder: (context, url) {
                        return SizedBox(
                          width: 270,
                          height: 150,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.3),
                            highlightColor: Colors.grey.withOpacity(0.1),
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      height: 200,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingBarIndicator(
                        rating: movie.voteAverage! / 2,
                        itemCount: 5,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: kMikadoYellow,
                        ),
                        itemSize: 10,
                      ),
                      Text('${movie.voteAverage}')
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
