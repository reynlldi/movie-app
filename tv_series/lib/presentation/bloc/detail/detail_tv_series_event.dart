part of 'detail_tv_series_bloc.dart';

sealed class DetailTvSeriesEvent extends Equatable {
  const DetailTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchDetailTvSeries extends DetailTvSeriesEvent {
  final int id;

  const FetchDetailTvSeries(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlistTvSeries extends DetailTvSeriesEvent {
  final TvSeriesDetail detail;

  const AddWatchlistTvSeries(this.detail);

  @override
  List<Object> get props => [detail];
}

class RemoveWatchlistTvSeriess extends DetailTvSeriesEvent {
  final TvSeriesDetail detail;

  const RemoveWatchlistTvSeriess(this.detail);

  @override
  List<Object> get props => [detail];
}

class LoadWatchlistStatusTvSeries extends DetailTvSeriesEvent {
  final int id;

  const LoadWatchlistStatusTvSeries(this.id);

  @override
  List<Object> get props => [id];
}
