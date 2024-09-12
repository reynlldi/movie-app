part of 'popular_movies_bloc.dart';

abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object> get props => [];
}

final class PopularMoviesInitial extends PopularMoviesState {}

class PopularMoviesEmpty extends PopularMoviesState {}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesError extends PopularMoviesState {
  final String message;

  const PopularMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMoviesHasData extends PopularMoviesState {
  final List<Movie> result;

  const PopularMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}
