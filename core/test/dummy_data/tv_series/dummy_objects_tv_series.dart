import 'package:core/data/models/tv_series/tv_series_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';

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

final testTvSeriesList = [testTvSeries];

const testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  firstAirDate: '2022-10-10',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1,
  lastAirDate: '2022-10-10',
  name: 'name',
  numberOfEpisodes: 12,
  numberOfSeasons: 6,
  overview: 'overview',
  posterPath: 'posterPath',
  seasons: [
    Season(
      airDate: '2022-10-10',
      episodeCount: 15,
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 10,
    ),
  ],
  status: 'status',
  tagline: 'tagline',
  type: 'type',
  voteAverage: 8.3,
  voteCount: 1200,
  languages: ["af", "en"],
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
