// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/widgets/shimmer_carousel.dart';
import 'package:core/presentation/widgets/shimmer_home.dart';
import 'package:core/utils/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tv_series/presentation/bloc/airing_today/airing_today_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing/now_playing_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_series_carousel.dart';

class TvSeriesListPage extends StatefulWidget {
  const TvSeriesListPage({super.key});

  @override
  State<TvSeriesListPage> createState() => _TvSeriesListPageState();
}

class _TvSeriesListPageState extends State<TvSeriesListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AiringTodayTvSeriesBloc>().add(FetchAiringTodayTvSeries());
      context.read<NowPlayingTvSeriesBloc>().add(FetchNowPlayingTvSeries());
      context.read<PopularTvSeriesBloc>().add(FetchPopularTvSseries());
      context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tv Series"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchTvSeriesRoute);
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
                'Airing Today',
                style: kHeading6,
              ),
              BlocBuilder<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
                builder: (context, state) {
                  if (state is AiringTodayTvSeriesLoading) {
                    return const ShimmerCarousel();
                  } else if (state is AiringTodayTvSeriesHasData) {
                    return TvSeriesCarousel(state.result);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () =>
                    Navigator.pushNamed(context, nowPlayingTvSeriesRoute),
              ),
              BlocBuilder<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
                builder: (context, state) {
                  if (state is NowPlayingTvSeriesLoading) {
                    return const ShimmerHome();
                  } else if (state is NowPlayingTvSeriesHasData) {
                    return TvSeriesList(state.result);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, popularTvSeriesRoute),
              ),
              BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
                builder: (context, state) {
                  if (state is PopularTvSeriesLoading) {
                    return const ShimmerHome();
                  } else if (state is PopularTvSeriesHasData) {
                    return TvSeriesList(state.result);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, topRatedTvSeriesRoute),
              ),
              BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
                builder: (context, state) {
                  if (state is TopRatedTvSeriesLoading) {
                    return const ShimmerHome();
                  } else if (state is TopRatedTvSeriesHasData) {
                    return TvSeriesList(state.result);
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

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = tvSeries[index];
          return Container(
            width: 150,
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  detailTvSeriesRoute,
                  arguments: data.id,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: '$baseImageUrl${data.posterPath}',
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
                    data.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingBarIndicator(
                        rating: data.voteAverage! / 2,
                        itemCount: 5,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: kMikadoYellow,
                        ),
                        itemSize: 10,
                      ),
                      Text('${data.voteAverage}')
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
