import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/get_upcoming_movies.dart';
import 'package:movies/presentation/bloc/up_coming/up_coming_movies_bloc.dart';

import 'up_coming_movies_bloc_test.mocks.dart';

@GenerateMocks([GetUpcomingMovies])
void main() {
  late UpComingMoviesBloc upComingMoviesBloc;
  late MockGetUpcomingMovies mockGetUpcomingMovies;

  setUp(() {
    mockGetUpcomingMovies = MockGetUpcomingMovies();
    upComingMoviesBloc = UpComingMoviesBloc(mockGetUpcomingMovies);
  });

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

  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    expect(upComingMoviesBloc.state, UpComingMoviesInitial());
  });

  blocTest<UpComingMoviesBloc, UpComingMoviesState>(
    "Should emit [Loading, HasData] when data is gotten successfully",
    build: () {
      when(mockGetUpcomingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return upComingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchUpComingMovies()),
    expect: () => [
      UpComingMoviesLoading(),
      UpComingMoviesHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetUpcomingMovies.execute());
    },
  );

  blocTest<UpComingMoviesBloc, UpComingMoviesState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetUpcomingMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return upComingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchUpComingMovies()),
    expect: () => [
      UpComingMoviesLoading(),
      UpComingMoviesEmpty(),
    ],
    verify: (bloc) => verify(mockGetUpcomingMovies.execute()),
  );

  blocTest<UpComingMoviesBloc, UpComingMoviesState>(
    'Should emit [Loading, Error] when get up coming is unsuccessful',
    build: () {
      when(mockGetUpcomingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return upComingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchUpComingMovies()),
    expect: () => [
      UpComingMoviesLoading(),
      const UpComingMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetUpcomingMovies.execute());
    },
  );
}
