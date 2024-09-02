import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:flutter/material.dart';

class PopularTvSeriesNotifier extends ChangeNotifier {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesNotifier({required this.getPopularTvSeries});

  List<TvSeries> _popularTvSeries = [];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  RequestState _popularState = RequestState.empty;
  RequestState get popularState => _popularState;

  String _message = "";
  String get message => _message;

  Future<void> fetchPopularTvSeries() async {
    _popularState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _popularState = RequestState.loaded;
        _popularTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
