part of 'detail_tv_series_bloc.dart';

class DetailTvSeriesState extends Equatable {
  final TvSeriesDetail? tvSeries;
  final RequestState tvSeriesState;
  final List<TvSeries> tvSeriesRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const DetailTvSeriesState({
    required this.tvSeries,
    required this.tvSeriesState,
    required this.tvSeriesRecommendations,
    required this.recommendationState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  DetailTvSeriesState copyWith({
    TvSeriesDetail? tvSeries,
    RequestState? tvSeriesState,
    List<TvSeries>? tvSeriesRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return DetailTvSeriesState(
      tvSeries: tvSeries ?? this.tvSeries,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeries,
        tvSeriesState,
        tvSeriesRecommendations,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];

  factory DetailTvSeriesState.initial() {
    return const DetailTvSeriesState(
      tvSeries: null,
      tvSeriesState: RequestState.empty,
      tvSeriesRecommendations: [],
      recommendationState: RequestState.empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }
}
