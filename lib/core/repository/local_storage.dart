import 'package:finoco/core/models/login_helper.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static LocalStorage? _instance;

  factory LocalStorage() => getInstance();

  LocalStorage._internal();

  static LocalStorage getInstance() {
    _instance ??= LocalStorage._internal();
    return _instance!;
  }

  final _box = GetStorage();

  Future<void> setAccessToken(String accessToken) async {
    await _box.write("accessToken", accessToken);
  }

  Future<String?> getAccessToken() async {
    return _box.read("accessToken");
  }

  Future<void> deleteToken() async {
    await _box.remove("accessToken");
  }

  Future<void> setLastLogin(LogInHelper login) async {
    await _box.write(login.email!, login.toJson());
  }

  Future<String?> getLastLogin(String email) async {
    return _box.read(email);
  }

  Future<void> deleteLastLogin(String email) async {
    _box.remove(email);
  }

  Future<void> setSaveLogin(bool saveLogin) async {
    await _box.write("SaveLogin", saveLogin);
  }

  Future<bool?> getSaveLogin() async {
    return _box.read("SaveLogin");
  }

  Future<void> deleteSaveLogin() async {
    await _box.remove("SaveLogin");
  }

  Future<List<String>> setFavorite(String id) async {
    List? res = _box.read('favorite');

    if (res == null || res.isEmpty) {
      await _box.write('favorite', [id]);
      res = [id];
    } else {
      res.add(id);
      await _box.write('favorite', res);
    }
    return res.cast<String>();
  }

  Future<List<String>> deleteFavorite(String id) async {
    List<String> res = (_box.read('favorite') as List?)?.cast<String>() ?? [];
    if (res.isNotEmpty) {
      res.removeWhere((element) => element == id);
      await _box.write('favorite', res);
      return res;
    }
    return [];
  }

  List<String>? getFavorites() {
    return _box.read('favorite')?.cast<String>();
  }
}
