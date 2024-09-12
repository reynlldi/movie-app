import 'package:core/domain/entities/tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_airing_today_tv_series.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetAiringTodayTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetAiringTodayTvSeries(mockTvSeriesRepository);
  });

  final tvSeries = <TvSeries>[];

  test('should get list of tv series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.getAiringTodayTvSeries())
        .thenAnswer((_) async => Right(tvSeries));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tvSeries));
  });
}
