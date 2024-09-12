part of 'up_coming_movies_bloc.dart';

sealed class UpComingMoviesEvent extends Equatable {
  const UpComingMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchUpComingMovies extends UpComingMoviesEvent {}
