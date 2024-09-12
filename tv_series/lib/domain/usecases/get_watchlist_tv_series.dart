import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:dartz/dartz.dart';

class GetWatchlistTvSeries {
  final TvSeriesRepository repository;

  GetWatchlistTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getWatchlistTvSeries();
  }
}
