import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/episode.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_detail_season.dart';
import 'package:tv_series/presentation/bloc/season/detail_season_bloc.dart';

import 'detail_season_bloc_test.mocks.dart';

@GenerateMocks([GetDetailSeason])
void main() {
  late DetailSeasonBloc detailSeasonBloc;
  late MockGetDetailSeason mockGetDetailSeason;

  setUp(() {
    mockGetDetailSeason = MockGetDetailSeason();
    detailSeasonBloc = DetailSeasonBloc(mockGetDetailSeason);
  });

  const testSeasonDetail = SeasonDetail(
    id: 1,
    airDate: '2020-10-10',
    episodes: [
      Episode(
        airDate: '2020-10-10',
        episodeNumber: 1,
        id: 1,
        name: 'name',
        overview: 'overview',
        productionCode: 'productionCode',
        seasonNumber: 1,
        stillPath: 'stillPath',
        voteAverage: 8.3,
        voteCount: 1500,
      )
    ],
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  test('initial state should be empty', () {
    expect(detailSeasonBloc.state, DetailSeasonInitial());
  });

  blocTest<DetailSeasonBloc, DetailSeasonState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetDetailSeason.execute(1, 1))
          .thenAnswer((_) async => const Right(testSeasonDetail));
      return detailSeasonBloc;
    },
    act: (bloc) => bloc.add(const FetchSeasonDetail(1, 1)),
    expect: () => [
      DetailSeasonLoading(),
      const DetailSeasonHasData(testSeasonDetail),
    ],
    verify: (bloc) => verify(
      mockGetDetailSeason.execute(1, 1),
    ),
  );

  blocTest<DetailSeasonBloc, DetailSeasonState>(
    'Should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetDetailSeason.execute(1, 1))
          .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return detailSeasonBloc;
    },
    act: (bloc) => bloc.add(const FetchSeasonDetail(1, 1)),
    expect: () => [
      DetailSeasonLoading(),
      const DetailSeasonError("Server Failure"),
    ],
    verify: (bloc) => verify(
      mockGetDetailSeason.execute(1, 1),
    ),
  );
}
