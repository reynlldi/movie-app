import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/detail/detail_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';

class MockDetailTvSeriesBloc
    extends MockBloc<DetailTvSeriesEvent, DetailTvSeriesState>
    implements DetailTvSeriesBloc {}

void main() {
  late MockDetailTvSeriesBloc mockDetailTvSeriesBloc;

  setUp(() {
    mockDetailTvSeriesBloc = MockDetailTvSeriesBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<DetailTvSeriesBloc>.value(
      value: mockDetailTvSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

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

  testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailTvSeriesBloc.state).thenReturn(
      DetailTvSeriesState.initial().copyWith(
        tvSeriesState: RequestState.loaded,
        tvSeries: testTvSeriesDetail,
        recommendationState: RequestState.loaded,
        tvSeriesRecommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );

    // Act
    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.tap(find.byType(ElevatedButton));

    // Assert
    final watchlistButtonIcon = find.byIcon(Icons.add);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series is added to wathclist',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailTvSeriesBloc.state).thenReturn(
      DetailTvSeriesState.initial().copyWith(
        tvSeriesState: RequestState.loaded,
        tvSeries: testTvSeriesDetail,
        recommendationState: RequestState.loaded,
        tvSeriesRecommendations: [testTvSeries],
        isAddedToWatchlist: true,
      ),
    );

    // Act
    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.tap(find.byType(ElevatedButton));

    // Assert
    final watchlistButtonIcon = find.byIcon(Icons.check);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Movie detail page should display error text when no internet network',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailTvSeriesBloc.state).thenReturn(
      DetailTvSeriesState.initial().copyWith(
        tvSeriesState: RequestState.error,
        message: 'No internet connection',
      ),
    );

    // Act
    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.pump();

    // Assert
    final textErrorBarFinder = find.text('No internet connection');
    expect(textErrorBarFinder, findsOneWidget);
  });
}
