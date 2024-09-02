import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

class TopRatedTvSeriesNotifier extends ChangeNotifier {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesNotifier({required this.getTopRatedTvSeries});

  List<TvSeries> _topRatedTvSeries = [];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedState = RequestState.empty;
  RequestState get topRatedState => _topRatedState;

  String _message = "";
  String get message => _message;

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _topRatedState = RequestState.loaded;
        _topRatedTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
