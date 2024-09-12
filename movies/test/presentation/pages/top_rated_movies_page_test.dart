import 'dart:io';

import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() {
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockTopRatedMoviesBloc,
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
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoading());

    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    // Assert
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesHasData([testMovie]));

    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(const TopRatedMoviesError('Error message'));

    // Act
    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    // Assert
    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
