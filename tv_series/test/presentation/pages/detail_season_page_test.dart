import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/episode.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/season/detail_season_bloc.dart';
import 'package:tv_series/presentation/pages/detail_season_page.dart';

class MockDetailSeasonBloc
    extends MockBloc<DetailSeasonEvent, DetailSeasonState>
    implements DetailSeasonBloc {}

void main() {
  late MockDetailSeasonBloc mockDetailSeasonBloc;

  setUp(() {
    mockDetailSeasonBloc = MockDetailSeasonBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<DetailSeasonBloc>.value(
      value: mockDetailSeasonBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

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

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailSeasonBloc.state).thenReturn(DetailSeasonLoading());

    // Act
    await tester.pumpWidget(makeTestableWidget(const DetailSeasonPage(
      id: 1,
      seasonNumber: 1,
    )));

    // Assert
    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);
    final centerFinder = find.byWidgetPredicate((widget) =>
        widget is Center && widget.child is CircularProgressIndicator);
    expect(centerFinder, findsOneWidget);
    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailSeasonBloc.state)
        .thenReturn(const DetailSeasonHasData(testSeasonDetail));

    // Act
    await tester.pumpWidget(makeTestableWidget(const DetailSeasonPage(
      id: 1,
      seasonNumber: 1,
    )));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailSeasonBloc.state)
        .thenReturn(const DetailSeasonError('Error message'));

    // Act
    await tester.pumpWidget(makeTestableWidget(const DetailSeasonPage(
      id: 1,
      seasonNumber: 1,
    )));

    // Assert
    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
