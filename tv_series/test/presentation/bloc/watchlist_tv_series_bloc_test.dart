import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/watchlist/watchlist_tv_series_bloc.dart';

import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(mockGetWatchlistTvSeries);
  });

  final testWatchlistTvSeries = TvSeries.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tWatchlistTvSeries = <TvSeries>[testWatchlistTvSeries];

  test('initial state should be empty', () {
    expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesInitial());
  });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tWatchlistTvSeries));
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesHasData(tWatchlistTvSeries),
    ],
    verify: (bloc) => verify(mockGetWatchlistTvSeries.execute()),
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => const Right([]));
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesEmpty(),
    ],
    verify: (bloc) => verify(mockGetWatchlistTvSeries.execute()),
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'Should emit [Loading, Error] when get watchlist is unsuccessful',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      const WatchlistTvSeriesError('Database Failure'),
    ],
    verify: (bloc) => verify(mockGetWatchlistTvSeries.execute()),
  );
}
