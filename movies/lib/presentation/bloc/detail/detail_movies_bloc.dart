import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';

part 'detail_movies_event.dart';
part 'detail_movies_state.dart';

class DetailMoviesBloc extends Bloc<DetailMoviesEvent, DetailMoviesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  DetailMoviesBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(DetailMoviesState.initial()) {
    on<FetchDetailMovies>((event, emit) async {
      emit(state.copyWith(movieState: RequestState.loading));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            movieState: RequestState.error,
            message: failure.message,
          ));
        },
        (movie) {
          emit(state.copyWith(
            recommendationState: RequestState.loading,
            movieState: RequestState.loaded,
            movie: movie,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                recommendationState: RequestState.error,
                message: failure.message,
              ));
            },
            (movies) {
              if (movies.isNotEmpty) {
                emit(state.copyWith(
                  recommendationState: RequestState.loaded,
                  movieRecommendations: movies,
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

    on<AddWatchlistMovies>((event, emit) async {
      final result = await saveWatchlist.execute(event.detail);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(LoadWatchlistStatusMovies(event.detail.id));
    });

    on<RemoveWatchlistMovies>((event, emit) async {
      final result = await removeWatchlist.execute(event.detail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusMovies(event.detail.id));
    });

    on<LoadWatchlistStatusMovies>((event, emit) async {
      final status = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}
