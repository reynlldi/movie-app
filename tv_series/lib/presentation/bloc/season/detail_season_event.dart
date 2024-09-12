part of 'detail_season_bloc.dart';

sealed class DetailSeasonEvent extends Equatable {
  const DetailSeasonEvent();

  @override
  List<Object> get props => [];
}

class FetchSeasonDetail extends DetailSeasonEvent {
  final int id;
  final int seasonNumber;

  const FetchSeasonDetail(
    this.id,
    this.seasonNumber,
  );

  @override
  List<Object> get props => [id, seasonNumber];
}
