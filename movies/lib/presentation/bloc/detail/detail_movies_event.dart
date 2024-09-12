part of 'detail_movies_bloc.dart';

sealed class DetailMoviesEvent extends Equatable {
  const DetailMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchDetailMovies extends DetailMoviesEvent {
  final int id;

  const FetchDetailMovies(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlistMovies extends DetailMoviesEvent {
  final MovieDetail detail;

  const AddWatchlistMovies(this.detail);

  @override
  List<Object> get props => [detail];
}

class RemoveWatchlistMovies extends DetailMoviesEvent {
  final MovieDetail detail;

  const RemoveWatchlistMovies(this.detail);

  @override
  List<Object> get props => [detail];
}

class LoadWatchlistStatusMovies extends DetailMoviesEvent {
  final int id;

  const LoadWatchlistStatusMovies(this.id);

  @override
  List<Object> get props => [id];
}
