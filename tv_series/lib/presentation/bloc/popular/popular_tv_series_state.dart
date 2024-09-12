part of 'popular_tv_series_bloc.dart';

sealed class PopularTvSeriesState extends Equatable {
  const PopularTvSeriesState();

  @override
  List<Object> get props => [];
}

final class PopularTvSeriesInitial extends PopularTvSeriesState {}

class PopularTvSeriesEmpty extends PopularTvSeriesState {}

class PopularTvSeriesLoading extends PopularTvSeriesState {}

class PopularTvSeriesError extends PopularTvSeriesState {
  final String message;

  const PopularTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTvSeriesHasData extends PopularTvSeriesState {
  final List<TvSeries> result;

  const PopularTvSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
