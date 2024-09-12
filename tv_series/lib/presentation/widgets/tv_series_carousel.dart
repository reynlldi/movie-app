import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TvSeriesCarousel extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesCarousel(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: tvSeries.length,
      itemBuilder: (context, index, realIndex) {
        final data = tvSeries[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              detailTvSeriesRoute,
              arguments: data.id,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: '$baseImageUrl${data.posterPath}',
                    errorWidget: (context, url, error) => const SizedBox(
                      width: 300,
                      height: 300,
                      child: Icon(Icons.error),
                    ),
                    placeholder: (context, url) {
                      return SizedBox(
                        width: 300,
                        height: 300,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.3),
                          highlightColor: Colors.grey.withOpacity(0.1),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        data.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.6,
      ),
    );
  }
}
