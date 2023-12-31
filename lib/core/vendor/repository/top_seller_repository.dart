import 'dart:async';

import '../api/common/ps_resource.dart';
import '../api/common/ps_status.dart';
import '../api/ps_api_service.dart';
import '../db/common/ps_data_source_manager.dart';
import '../db/user_dao.dart';
import '../viewobject/common/ps_holder.dart';
import '../viewobject/holder/request_path_holder.dart';
import '../viewobject/user.dart';
import 'Common/ps_repository.dart';

class TopSellerRepository extends PsRepository {
  TopSellerRepository(
      {required PsApiService psApiService, required UserDao userDao}) {
    _psApiService = psApiService;
    _userDao = userDao;
  }

  String primaryKey = 'user_id';
  String mapKey = 'map_key';
  late PsApiService _psApiService;
  late UserDao _userDao;

  Future<dynamic> insert(User user) async {
    return _userDao.insert(primaryKey, user);
  }

  Future<dynamic> update(User user) async {
    return _userDao.update(user);
  }

  Future<dynamic> delete(User user) async {
    return _userDao.delete(user);
  }

  @override
  Future<void> loadDataList({
    required StreamController<PsResource<List<dynamic>>> streamController,
    required int limit,
    required int offset,
    required DataConfiguration dataConfig,
    PsHolder<dynamic>? requestBodyHolder,
    RequestPathHolder? requestPathHolder,
  }) async {
    await startResourceSinkingForList(
      dao: _userDao,
      streamController: streamController,
      dataConfig: dataConfig,
      serverRequestCallback: () => _psApiService.getTopSellerList(
          requestPathHolder!.loginUserId!,
          requestPathHolder.headerToken!,
          limit,
          offset,
          requestPathHolder.languageCode ?? 'en'),
    );
  }

  @override
  Future<void> loadNextDataList({
    required StreamController<PsResource<List<dynamic>>> streamController,
    required int limit,
    required int offset,
    PsHolder<dynamic>? requestBodyHolder,
    RequestPathHolder? requestPathHolder,
    required DataConfiguration dataConfig,
  }) async {
    await startResourceSinkingForNextList(
        dao: _userDao,
        streamController: streamController,
        loadingStatus: PsStatus.PROGRESS_LOADING,
        dataConfig: dataConfig,
        serverRequestCallback: () => _psApiService.getTopSellerList(
            requestPathHolder!.loginUserId,
            requestPathHolder.headerToken!,
            limit,
            offset,
            requestPathHolder.languageCode ?? 'en'));
  }
}
