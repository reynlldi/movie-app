import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:flutter/material.dart';

class TvSeriesSearchNotifier extends ChangeNotifier {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchNotifier({required this.searchTvSeries});

  List<TvSeries> _searchResult = [];
  List<TvSeries> get searchResult => _searchResult;

  RequestState _searchState = RequestState.empty;
  RequestState get searchState => _searchState;

  String _message = "";
  String get message => _message;

  Future<void> fetchTvSeriesSearch(String query) async {
    _searchState = RequestState.loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) {
        _searchState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _searchState = RequestState.loaded;
        _searchResult = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
