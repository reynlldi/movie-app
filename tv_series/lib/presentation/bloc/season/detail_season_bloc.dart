import 'package:core/domain/entities/season_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_detail_season.dart';

part 'detail_season_event.dart';
part 'detail_season_state.dart';

class DetailSeasonBloc extends Bloc<DetailSeasonEvent, DetailSeasonState> {
  final GetDetailSeason _getDetailSeason;

  DetailSeasonBloc(this._getDetailSeason) : super(DetailSeasonInitial()) {
    on<FetchSeasonDetail>((event, emit) async {
      emit(DetailSeasonLoading());

      final result = await _getDetailSeason.execute(
        event.id,
        event.seasonNumber,
      );

      result.fold(
        (failure) {
          emit(DetailSeasonError(failure.message));
        },
        (data) {
          emit(DetailSeasonHasData(data));
        },
      );
    });
  }
}
