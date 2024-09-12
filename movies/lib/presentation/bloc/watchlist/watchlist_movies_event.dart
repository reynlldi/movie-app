part of 'watchlist_movies_bloc.dart';

sealed class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistMovies extends WatchlistMoviesEvent {}
