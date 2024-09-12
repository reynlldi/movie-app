import 'dart:io';

import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/top_rated/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

void main() {
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  setUp(() {
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockTopRatedTvSeriesBloc,
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

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockTopRatedTvSeriesBloc.state)
        .thenReturn(TopRatedTvSeriesLoading());

    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    // Assert
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockTopRatedTvSeriesBloc.state)
        .thenReturn(TopRatedTvSeriesHasData([testTvSeries]));

    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockTopRatedTvSeriesBloc.state)
        .thenReturn(const TopRatedTvSeriesError('Error message'));

    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    // Assert
    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
