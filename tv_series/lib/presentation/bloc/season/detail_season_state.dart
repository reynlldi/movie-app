part of 'detail_season_bloc.dart';

sealed class DetailSeasonState extends Equatable {
  const DetailSeasonState();

  @override
  List<Object> get props => [];
}

class DetailSeasonInitial extends DetailSeasonState {}

class DetailSeasonEmpty extends DetailSeasonState {}

class DetailSeasonLoading extends DetailSeasonState {}

class DetailSeasonHasData extends DetailSeasonState {
  final SeasonDetail result;

  const DetailSeasonHasData(this.result);

  @override
  List<Object> get props => [result];
}

class DetailSeasonError extends DetailSeasonState {
  final String message;

  const DetailSeasonError(this.message);

  @override
  List<Object> get props => [message];
}
