import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies/presentation/bloc/detail/detail_movies_bloc.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';

class MockDetailMoviesBloc
    extends MockBloc<DetailMoviesEvent, DetailMoviesState>
    implements DetailMoviesBloc {}

void main() {
  late MockDetailMoviesBloc mockDetailMoviesBloc;

  setUp(() {
    mockDetailMoviesBloc = MockDetailMoviesBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<DetailMoviesBloc>.value(
      value: mockDetailMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

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

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailMoviesBloc.state).thenReturn(
      DetailMoviesState.initial().copyWith(
        movieState: RequestState.loaded,
        movie: testMovieDetail,
        recommendationState: RequestState.loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    // Act
    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.tap(find.byType(ElevatedButton));

    // Assert
    final watchlistButtonIcon = find.byIcon(Icons.add);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailMoviesBloc.state).thenReturn(
      DetailMoviesState.initial().copyWith(
        movieState: RequestState.loaded,
        movie: testMovieDetail,
        recommendationState: RequestState.loaded,
        movieRecommendations: [testMovie],
        isAddedToWatchlist: true,
      ),
    );

    // Act
    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.tap(find.byType(ElevatedButton));

    // Assert
    final watchlistButtonIcon = find.byIcon(Icons.check);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Movie detail page should display error text when no internet network',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockDetailMoviesBloc.state).thenReturn(
      DetailMoviesState.initial().copyWith(
        movieState: RequestState.error,
        message: 'No internet connection',
      ),
    );

    // Act
    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    // Assert
    final textErrorBarFinder = find.text('No internet connection');
    expect(textErrorBarFinder, findsOneWidget);
  });
}
