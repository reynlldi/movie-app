import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_airing_today_tv_series.dart';
import 'package:tv_series/presentation/bloc/airing_today/airing_today_tv_series_bloc.dart';

import 'airing_today_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTvSeries])
void main() {
  late AiringTodayTvSeriesBloc airingTodayTvSeriesBloc;
  late MockGetAiringTodayTvSeries mockGetAiringTodayTvSeries;

  setUp(() {
    mockGetAiringTodayTvSeries = MockGetAiringTodayTvSeries();
    airingTodayTvSeriesBloc =
        AiringTodayTvSeriesBloc(mockGetAiringTodayTvSeries);
  });

  final testTvSeries = TvSeries(
    adult: false,
    posterPath: "/v9nGSRx5lFz6KEgfmgHJMSgaARC.jpg",
    popularity: 3978.961,
    id: 206559,
    backdropPath: "/mu3lEhGovyhKHPJzb7HNYtZUCDT.jpg",
    voteAverage: 5.632,
    overview:
        "A South African Afrikaans soap opera. It is set in and around the fictional private hospital, Binneland Kliniek, in Pretoria, and the storyline follows the trials, trauma and tribulations of the staff and patients of the hospital.",
    firstAirDate: "2005-10-13",
    originCountry: const ["ZA"],
    genreIds: const [10766],
    originalLanguage: "af",
    voteCount: 73,
    name: 'Binnelanders',
    originalName: 'Binnelanders',
  );

  final tTvSeriesList = <TvSeries>[testTvSeries];

  test('initial state should be empty', () {
    expect(airingTodayTvSeriesBloc.state, AiringTodayTvSeriesInitial());
  });

  blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
    "Should emit [Loading, HasData] when data is gotten successfully",
    build: () {
      when(mockGetAiringTodayTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      return airingTodayTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
    expect: () => [
      AiringTodayTvSeriesLoading(),
      AiringTodayTvSeriesHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTvSeries.execute());
    },
  );

  blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetAiringTodayTvSeries.execute())
          .thenAnswer((_) async => const Right([]));
      return airingTodayTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
    expect: () => [
      AiringTodayTvSeriesLoading(),
      AiringTodayTvSeriesEmpty(),
    ],
    verify: (bloc) => verify(mockGetAiringTodayTvSeries.execute()),
  );

  blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
    'Should emit [Loading, Error] when get airing today is unsuccessful',
    build: () {
      when(mockGetAiringTodayTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return airingTodayTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
    expect: () => [
      AiringTodayTvSeriesLoading(),
      const AiringTodayTvSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTvSeries.execute());
    },
  );
}
