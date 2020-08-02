abstract class TorrentUsecases<Type, Params> {
  Future<Type> call(Params params);
}
