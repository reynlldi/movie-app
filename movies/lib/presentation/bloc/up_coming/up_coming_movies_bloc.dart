import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_upcoming_movies.dart';

part 'up_coming_movies_event.dart';
part 'up_coming_movies_state.dart';

class UpComingMoviesBloc
    extends Bloc<UpComingMoviesEvent, UpComingMoviesState> {
  final GetUpcomingMovies _getUpcomingMovies;

  UpComingMoviesBloc(this._getUpcomingMovies) : super(UpComingMoviesInitial()) {
    on<FetchUpComingMovies>((event, emit) async {
      emit(UpComingMoviesLoading());

      final result = await _getUpcomingMovies.execute();

      result.fold(
        (failure) {
          emit(UpComingMoviesError(failure.message));
        },
        (data) {
          if (data.isNotEmpty) {
            emit(UpComingMoviesHasData(data));
          } else {
            emit(UpComingMoviesEmpty());
          }
        },
      );
    });
  }
}
