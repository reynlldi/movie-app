import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/search_tv_series.dart';
import 'package:tv_series/presentation/bloc/search/search_tv_series_bloc.dart';

import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchTvSeriesBloc searchTvSeriesBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    searchTvSeriesBloc = SearchTvSeriesBloc(mockSearchTvSeries);
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
  const tQuery = 'Binnelanders';

  test('initial state should be empty', () {
    expect(searchTvSeriesBloc.state, SearchTvSeriesInitial());
  });

  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
    "Should emit [Loading, HasData] when data is gotten successfully",
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvSeriesList));
      return searchTvSeriesBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvSeriesLoading(),
      SearchTvSeriesHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
    'Should emit [Loading, Empty] when get search is empty',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => const Right([]));
      return searchTvSeriesBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvSeriesLoading(),
      SearchTvSeriesEmpty(),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchTvSeriesBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvSeriesLoading(),
      const SearchTvSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
