import 'dart:io';

import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies/presentation/bloc/watchlist/watchlist_movies_bloc.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

void main() {
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUp(() {
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMoviesBloc>.value(
      value: mockWatchlistMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final testMovie = Movie(
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

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockWatchlistMoviesBloc.state)
        .thenReturn(WatchlistMoviesLoading());

    // Act
    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    // Assert
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockWatchlistMoviesBloc.state)
        .thenReturn(WatchlistMoviesHasData([testMovie]));

    // Act
    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockWatchlistMoviesBloc.state)
        .thenReturn(const WatchlistMoviesError('Error message'));

    // Act
    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    // Assert
    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text when data is empty',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockWatchlistMoviesBloc.state)
        .thenReturn(WatchlistMoviesEmpty());

    // Act
    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    // Assert
    final textErrorBarFinder = find.text('Oops, your watchlist is empty :)');
    expect(textErrorBarFinder, findsOneWidget);
  });
}
