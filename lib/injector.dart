import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:torrentsearch/features/torrent/data/datasources/torrent_api_source.dart';
import 'package:torrentsearch/features/torrent/data/repositories/torrent_repository_impl.dart';
import 'package:torrentsearch/features/torrent/domain/repositories/torrent_repository.dart';
import 'package:torrentsearch/features/torrent/domain/usecases/get_magnet.dart';
import 'package:torrentsearch/features/torrent/domain/usecases/get_torrent.dart';
import 'package:torrentsearch/features/torrent/presentation/bloc/torrent_bloc.dart';

final sl = GetIt.I;

Future<void> initInjector() async {
  // Bloc
  sl.registerFactory(
    () => TorrentBloc(
//      getRecent: sl(),
      getTorrent: sl(),
      getMagnet: sl(),
//      getRecentData: sl(),
//      getSpecificRecent: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTorrent(sl()));
//  sl.registerLazySingleton(() => GetRecent(sl()));
  sl.registerLazySingleton(() => GetMagnet(sl()));
//  sl.registerLazySingleton(() => GetRecentData(sl()));
//  sl.registerLazySingleton(() => GetSpecificRecent(sl()));

  // Repository
  sl.registerLazySingleton<TorrentRepository>(
      () => TorrentRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<TorrentApiDataSource>(
    () => TorrentApiDataSourceImpl(sl()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
}
