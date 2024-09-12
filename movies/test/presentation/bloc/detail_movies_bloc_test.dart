import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';
import 'package:movies/presentation/bloc/detail/detail_movies_bloc.dart';

import 'detail_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late DetailMoviesBloc detailMoviesBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    detailMoviesBloc = DetailMoviesBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getWatchListStatus: mockGetWatchListStatus,
    );
  });

  const tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovies = <Movie>[tMovie];

  const testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  group('Get Movie Detail', () {
    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailMovies(tId)),
      expect: () => [
        DetailMoviesState.initial().copyWith(
          movieState: RequestState.loading,
        ),
        DetailMoviesState.initial().copyWith(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loading,
        ),
        DetailMoviesState.initial().copyWith(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loaded,
          movieRecommendations: tMovies,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Shoud emit [Empty] when get recommendations movie Empty',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailMovies(tId)),
      expect: () => [
        DetailMoviesState.initial().copyWith(
          movieState: RequestState.loading,
        ),
        DetailMoviesState.initial().copyWith(
          recommendationState: RequestState.loading,
          movieState: RequestState.loaded,
          movie: testMovieDetail,
        ),
        DetailMoviesState.initial().copyWith(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.empty,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Shoud emit [Error] when get detail movie failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Movie Failed')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailMovies(tId)),
      expect: () => [
        DetailMoviesState.initial().copyWith(
          movieState: RequestState.loading,
        ),
        DetailMoviesState.initial().copyWith(
          movieState: RequestState.error,
          message: 'Movie Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('Add Watchlist', () {
    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const AddWatchlistMovies(testMovieDetail)),
      expect: () => [
        DetailMoviesState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        DetailMoviesState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Shoud emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('Failed Add Watchlist')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const AddWatchlistMovies(testMovieDetail)),
      expect: () => [
        DetailMoviesState.initial()
            .copyWith(watchlistMessage: 'Failed Add Watchlist'),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );
  });

  group('Remove Watchlist', () {
    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const RemoveWatchlistMovies(testMovieDetail)),
      expect: () => [
        DetailMoviesState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Shoud emit [WatchlistMessage] when failed remove from watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('Failed remove Watchlist')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const RemoveWatchlistMovies(testMovieDetail)),
      expect: () => [
        DetailMoviesState.initial()
            .copyWith(watchlistMessage: 'Failed remove Watchlist'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );
  });

  group('Load Watchlist status', () {
    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Should emit [WatchlistStatus] is true Load Watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovies(tId)),
      expect: () => [
        DetailMoviesState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => verify(mockGetWatchListStatus.execute(tId)),
    );

    blocTest<DetailMoviesBloc, DetailMoviesState>(
      'Should emit [WatchlistStatus] is false Load Watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return detailMoviesBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovies(tId)),
      expect: () => [
        DetailMoviesState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => verify(mockGetWatchListStatus.execute(tId)),
    );
  });
}
