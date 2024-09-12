import 'package:core/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_airing_today_tv_series.dart';

part 'airing_today_tv_series_event.dart';
part 'airing_today_tv_series_state.dart';

class AiringTodayTvSeriesBloc
    extends Bloc<AiringTodayTvSeriesEvent, AiringTodayTvSeriesState> {
  final GetAiringTodayTvSeries _getAiringTodayTvSeries;

  AiringTodayTvSeriesBloc(this._getAiringTodayTvSeries)
      : super(AiringTodayTvSeriesInitial()) {
    on<FetchAiringTodayTvSeries>((event, emit) async {
      emit(AiringTodayTvSeriesLoading());

      final result = await _getAiringTodayTvSeries.execute();

      result.fold(
        (failure) {
          emit(AiringTodayTvSeriesError(failure.message));
        },
        (data) {
          if (data.isNotEmpty) {
            emit(AiringTodayTvSeriesHasData(data));
          } else {
            emit(AiringTodayTvSeriesEmpty());
          }
        },
      );
    });
  }
}
