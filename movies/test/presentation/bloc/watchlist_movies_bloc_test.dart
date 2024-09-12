import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/presentation/bloc/watchlist/watchlist_movies_bloc.dart';

import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  final testWatchlistMovie = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tWatchlistMovie = <Movie>[testWatchlistMovie];

  test('initial state should be empty', () {
    expect(watchlistMoviesBloc.state, WatchlistMoviesInitial());
  });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tWatchlistMovie));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesHasData(tWatchlistMovie),
    ],
    verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesEmpty(),
    ],
    verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Loading, Error] when get watchlist is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMoviesLoading(),
      const WatchlistMoviesError('Database Failure'),
    ],
    verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
  );
}
