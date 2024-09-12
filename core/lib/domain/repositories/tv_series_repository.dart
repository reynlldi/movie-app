import 'package:core/domain/entities/season_detail.dart';
import 'package:dartz/dartz.dart';
import '../../core.dart';
import '../entities/tv_series.dart';
import '../entities/tv_series_detail.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries();
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id);
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveWatchlistTvSeries(
      TvSeriesDetail tvSeries);
  Future<Either<Failure, String>> removeWatchlistTvSeries(
      TvSeriesDetail tvSeries);
  Future<bool> isAddedToWatchlistTvSeries(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries();
  Future<Either<Failure, List<TvSeries>>> getAiringTodayTvSeries();
  Future<Either<Failure, SeasonDetail>> getSeasionDetail(
    int id,
    int seasonNumber,
  );
}
