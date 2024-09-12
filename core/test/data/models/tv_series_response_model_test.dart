import 'dart:convert';

import 'package:core/data/models/tv_series/tv_series_model.dart';
import 'package:core/data/models/tv_series/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  const testTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: '/mu3lEhGovyhKHPJzb7HNYtZUCDT.jpg',
    genreIds: [10766],
    id: 206559,
    originCountry: ['ZA'],
    originalLanguage: 'af',
    originalName: 'Binnelanders',
    overview:
        'A South African Afrikaans soap opera. It is set in and around the fictional private hospital, Binneland Kliniek, in Pretoria, and the storyline follows the trials, trauma and tribulations of the staff and patients of the hospital.',
    popularity: 3978.961,
    posterPath: '/v9nGSRx5lFz6KEgfmgHJMSgaARC.jpg',
    firstAirDate: '2005-10-13',
    name: 'Binnelanders',
    voteAverage: 5.632,
    voteCount: 73,
  );

  const tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[testTvSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_series/now_playing.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/mu3lEhGovyhKHPJzb7HNYtZUCDT.jpg",
            "genre_ids": [10766],
            "id": 206559,
            "origin_country": ["ZA"],
            "original_language": "af",
            "original_name": "Binnelanders",
            "overview":
                "A South African Afrikaans soap opera. It is set in and around the fictional private hospital, Binneland Kliniek, in Pretoria, and the storyline follows the trials, trauma and tribulations of the staff and patients of the hospital.",
            "popularity": 3978.961,
            "poster_path": "/v9nGSRx5lFz6KEgfmgHJMSgaARC.jpg",
            "first_air_date": "2005-10-13",
            "name": "Binnelanders",
            "vote_average": 5.632,
            "vote_count": 73
          }
        ],
      };
      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
