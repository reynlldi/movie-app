import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:flutter/foundation.dart';

class NowPlayingMovieNotifier extends ChangeNotifier {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieNotifier({required this.getNowPlayingMovies});

  List<Movie> _nowPlayingMovie = [];
  List<Movie> get nowPlayingMovie => _nowPlayingMovie;

  RequestState _nowPlayingState = RequestState.empty;
  RequestState get nowPlayingState => _nowPlayingState;

  String _message = "";
  String get message => _message;

  Future<void> fetchPlayingNowTvSeries() async {
    _nowPlayingState = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _nowPlayingState = RequestState.loaded;
        _nowPlayingMovie = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
