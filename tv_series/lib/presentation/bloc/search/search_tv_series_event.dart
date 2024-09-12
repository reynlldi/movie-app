part of 'search_tv_series_bloc.dart';

sealed class SearchTvSeriesEvent extends Equatable {
  const SearchTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchTvSeriesEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
