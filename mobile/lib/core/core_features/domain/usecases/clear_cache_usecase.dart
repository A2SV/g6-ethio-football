import 'package:ethio_football/features/settings/domain/repositories/cache_repository.dart';

class ClearCacheUseCase {
  final CacheRepository _cacheRepository;

  ClearCacheUseCase(this._cacheRepository);

  Future<void> call() async {
    await _cacheRepository.clearCache();
  }
}
