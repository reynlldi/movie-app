import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:flutter/foundation.dart';

class NowPlayingTvSeriesNotifier extends ChangeNotifier {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  NowPlayingTvSeriesNotifier({required this.getNowPlayingTvSeries});

  List<TvSeries> _nowPlayingTvSeries = [];
  List<TvSeries> get nowPlayingTvSeries => _nowPlayingTvSeries;

  RequestState _nowPlayingState = RequestState.empty;
  RequestState get nowPlayingState => _nowPlayingState;

  String _message = "";
  String get message => _message;

  Future<void> fetchPlayingNowTvSeries() async {
    _nowPlayingState = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _nowPlayingState = RequestState.loaded;
        _nowPlayingTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
