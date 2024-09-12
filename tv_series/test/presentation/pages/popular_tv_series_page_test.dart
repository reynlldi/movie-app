import 'dart:io';

import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/popular/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';

class MockPopularTvSeriesBloc
    extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState>
    implements PopularTvSeriesBloc {}

void main() {
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;

  setUp(() {
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockPopularTvSeriesBloc,
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
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(PopularTvSeriesLoading());

    // Act
    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    // Assert
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(PopularTvSeriesHasData([testTvSeries]));

    // Act
    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockPopularTvSeriesBloc.state)
        .thenReturn(const PopularTvSeriesError('Error message'));

    // Act
    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    // Assert
    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
