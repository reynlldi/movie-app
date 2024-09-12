import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/detail/detail_tv_series_bloc.dart';

import 'detail_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchlistStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late DetailTvSeriesBloc detailTvSeriesBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchlistStatusTvSeries mockGetWatchlistStatusTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatusTvSeries = MockGetWatchlistStatusTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    detailTvSeriesBloc = DetailTvSeriesBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
      getWatchlistStatusTvSeries: mockGetWatchlistStatusTvSeries,
    );
  });

  const tId = 1;

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

  final tTvSeries = <TvSeries>[testTvSeries];

  const testTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    firstAirDate: '2022-10-10',
    genres: [Genre(id: 1, name: 'Drama')],
    id: 1,
    lastAirDate: '2022-10-10',
    name: 'name',
    numberOfEpisodes: 12,
    numberOfSeasons: 6,
    overview: 'overview',
    posterPath: 'posterPath',
    seasons: [
      Season(
        airDate: '2022-10-10',
        episodeCount: 15,
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 10,
      ),
    ],
    status: 'status',
    tagline: 'tagline',
    type: 'type',
    voteAverage: 8.3,
    voteCount: 1200,
    languages: ["af", "en"],
  );

  group('Get Movie Detail', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeries));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesState: RequestState.loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          tvSeriesRecommendations: tTvSeries,
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shoud emit [Empty] when get recommendations movie Empty',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesState: RequestState.loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          recommendationState: RequestState.loading,
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.empty,
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shoud emit [Error] when get detail movie failed',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Movie Failed')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeries));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesState: RequestState.loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesState: RequestState.error,
          message: 'Movie Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );
  });

  group('Add Watchlist', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const AddWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shoud emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('Failed Add Watchlist')));
        when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const AddWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial()
            .copyWith(watchlistMessage: 'Failed Add Watchlist'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id));
      },
    );
  });

  group('Remove Watchlist', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) =>
          bloc.add(const RemoveWatchlistTvSeriess(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shoud emit [WatchlistMessage] when failed remove from watchlist',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer(
                (_) async => Left(DatabaseFailure('Failed remove Watchlist')));
        when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) =>
          bloc.add(const RemoveWatchlistTvSeriess(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial()
            .copyWith(watchlistMessage: 'Failed remove Watchlist'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id));
      },
    );
  });

  group('Load Watchlist status', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistStatus] is true Load Watchlist',
      build: () {
        when(mockGetWatchlistStatusTvSeries.execute(tId))
            .thenAnswer((_) async => true);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => verify(mockGetWatchlistStatusTvSeries.execute(tId)),
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistStatus] is false Load Watchlist',
      build: () {
        when(mockGetWatchlistStatusTvSeries.execute(tId))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => verify(mockGetWatchlistStatusTvSeries.execute(tId)),
    );
  });
}
