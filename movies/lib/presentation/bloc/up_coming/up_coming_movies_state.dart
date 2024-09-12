part of 'up_coming_movies_bloc.dart';

sealed class UpComingMoviesState extends Equatable {
  const UpComingMoviesState();

  @override
  List<Object> get props => [];
}

class UpComingMoviesInitial extends UpComingMoviesState {}

class UpComingMoviesEmpty extends UpComingMoviesState {}

class UpComingMoviesLoading extends UpComingMoviesState {}

class UpComingMoviesError extends UpComingMoviesState {
  final String message;

  const UpComingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class UpComingMoviesHasData extends UpComingMoviesState {
  final List<Movie> result;

  const UpComingMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}
