import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:flutter/material.dart';

class WatchlistTvSeriesNotifier extends ChangeNotifier {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesNotifier({required this.getWatchlistTvSeries});

  List<TvSeries> _watchlistTvSeries = [];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        if (tvSeriesData.isNotEmpty) {
          _watchlistState = RequestState.loaded;
          _watchlistTvSeries = tvSeriesData;
          notifyListeners();
        } else {
          _watchlistState = RequestState.empty;
          notifyListeners();
        }
      },
    );
  }
}
