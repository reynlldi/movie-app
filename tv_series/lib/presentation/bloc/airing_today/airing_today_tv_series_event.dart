part of 'airing_today_tv_series_bloc.dart';

sealed class AiringTodayTvSeriesEvent extends Equatable {
  const AiringTodayTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchAiringTodayTvSeries extends AiringTodayTvSeriesEvent {}
