import 'dart:io';

import 'package:core/domain/entities/season_detail.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:dartz/dartz.dart';
import '../../core.dart';
import '../datasources/tv_series/tv_series_local_data_source.dart';
import '../datasources/tv_series/tv_series_remote_data_source.dart';
import '../models/tv_series/tv_series_table.dart';

class TvSeriesRepositoryImpl implements TvSeriesRepository {
  final TvSeriesRemoteDataSource tvSeriesRemoteDataSource;
  final TvSeriesLocalDataSource tvSeriesLocalDataSource;

  TvSeriesRepositoryImpl({
    required this.tvSeriesLocalDataSource,
    required this.tvSeriesRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries() async {
    try {
      final result = await tvSeriesRemoteDataSource.getNowPlayingTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() async {
    try {
      final result = await tvSeriesRemoteDataSource.getPopularTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() async {
    try {
      final result = await tvSeriesRemoteDataSource.getTopRatedTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) async {
    try {
      final result = await tvSeriesRemoteDataSource.getTvSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
      int id) async {
    try {
      final result =
          await tvSeriesRemoteDataSource.getTvSeriesRecommendstions(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() async {
    final result = await tvSeriesLocalDataSource.getWatchlistTvSeries();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchlistTvSeries(int id) async {
    final result = await tvSeriesLocalDataSource.getTvSeriesByid(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlistTvSeries(
      TvSeriesDetail tvSeries) async {
    try {
      final result = await tvSeriesLocalDataSource
          .removeWatchlistTvSeries(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlistTvSeries(
      TvSeriesDetail tvSeries) async {
    try {
      final result = await tvSeriesLocalDataSource
          .insertWatchlistTvSeries(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async {
    try {
      final result = await tvSeriesRemoteDataSource.serchTvSeries(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getAiringTodayTvSeries() async {
    try {
      final result = await tvSeriesRemoteDataSource.getAiringTodayTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SeasonDetail>> getSeasionDetail(
      int id, int seasonNumber) async {
    try {
      final result =
          await tvSeriesRemoteDataSource.getSeasionDetail(id, seasonNumber);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }
}
