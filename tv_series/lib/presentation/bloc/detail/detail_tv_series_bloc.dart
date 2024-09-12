import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';

part 'detail_tv_series_event.dart';
part 'detail_tv_series_state.dart';

class DetailTvSeriesBloc
    extends Bloc<DetailTvSeriesEvent, DetailTvSeriesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  DetailTvSeriesBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(DetailTvSeriesState.initial()) {
    on<FetchDetailTvSeries>((event, emit) async {
      emit(state.copyWith(tvSeriesState: RequestState.loading));

      final detailResult = await getTvSeriesDetail.execute(event.id);
      final recommendationResult =
          await getTvSeriesRecommendations.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            tvSeriesState: RequestState.error,
            message: failure.message,
          ));
        },
        (tvSeriesData) {
          emit(state.copyWith(
            recommendationState: RequestState.loading,
            tvSeriesState: RequestState.loaded,
            tvSeries: tvSeriesData,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                recommendationState: RequestState.error,
                message: failure.message,
              ));
            },
            (tvSeriesDatas) {
              if (tvSeriesDatas.isNotEmpty) {
                emit(state.copyWith(
                  recommendationState: RequestState.loaded,
                  tvSeriesRecommendations: tvSeriesDatas,
                ));
              } else {
                emit(state.copyWith(
                  recommendationState: RequestState.empty,
                ));
              }
            },
          );
        },
      );
    });

    on<AddWatchlistTvSeries>((event, emit) async {
      final result = await saveWatchlistTvSeries.execute(event.detail);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(LoadWatchlistStatusTvSeries(event.detail.id));
    });

    on<RemoveWatchlistTvSeriess>((event, emit) async {
      final result = await removeWatchlistTvSeries.execute(event.detail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTvSeries(event.detail.id));
    });

    on<LoadWatchlistStatusTvSeries>((event, emit) async {
      final status = await getWatchlistStatusTvSeries.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}
