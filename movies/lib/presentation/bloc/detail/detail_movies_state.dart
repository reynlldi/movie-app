part of 'detail_movies_bloc.dart';

class DetailMoviesState extends Equatable {
  final MovieDetail? movie;
  final RequestState movieState;
  final List<Movie> movieRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const DetailMoviesState({
    required this.movie,
    required this.movieState,
    required this.movieRecommendations,
    required this.recommendationState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  DetailMoviesState copyWith({
    MovieDetail? movie,
    RequestState? movieState,
    List<Movie>? movieRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return DetailMoviesState(
      movie: movie ?? this.movie,
      movieState: movieState ?? this.movieState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        movie,
        movieState,
        movieRecommendations,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];

  factory DetailMoviesState.initial() {
    return const DetailMoviesState(
      movie: null,
      movieState: RequestState.empty,
      movieRecommendations: [],
      recommendationState: RequestState.empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }
}
