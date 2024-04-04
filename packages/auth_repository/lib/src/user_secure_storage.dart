import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class UserSecureStorage {
  static const _tokenKey = 'app_chat-token';
  static const _phoneCodeKey = 'app_chat-phone-code';
  static const _idKey = 'app_chat-user-id';
  static const _avatarUrlKey = 'app_chat-avatar-url';
  static const _userNameKey = 'app_chat-user-name';
  static const _phoneKey = 'app_chat-phone-number';

  const UserSecureStorage({
    storage.FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const storage.FlutterSecureStorage();

  final storage.FlutterSecureStorage _secureStorage;

  Future<void> insertUserInfo(
          {String? token,
          String? refreshToken,
          String? id,
          String? avatarUrl,
          String? userName,
          String? phoneNumber}) =>
      Future.wait([
        _secureStorage.write(
          key: _tokenKey,
          value: token,
        ),
        _secureStorage.write(
          key: _phoneCodeKey,
          value: refreshToken,
        ),
        _secureStorage.write(
          key: _idKey,
          value: id,
        ),
        _secureStorage.write(key: _userNameKey, value: userName),
        _secureStorage.write(key: _avatarUrlKey, value: avatarUrl),
        _secureStorage.write(key: _phoneKey, value: phoneNumber),
      ]);

  Future<void> deleteUserInfo() => Future.wait([
        _secureStorage.delete(key: _tokenKey),
        _secureStorage.delete(key: _phoneCodeKey),
        _secureStorage.delete(key: _idKey),
        _secureStorage.delete(key: _avatarUrlKey),
        _secureStorage.delete(key: _userNameKey),
      ]);

  Future<String?> getUserToken() => _secureStorage.read(key: _tokenKey);

  Future<String?> getRefreshToken() => _secureStorage.read(key: _phoneCodeKey);

  Future<String?> getUserId() => _secureStorage.read(key: _idKey);

  Future<String?> getUserName() => _secureStorage.read(key: _userNameKey);

  Future<String?> getAvatarUrl() => _secureStorage.read(key: _avatarUrlKey);

  Future<String?> getPhoneNumber() => _secureStorage.read(key: _phoneKey);

  Future<String?> getPhoneCodeKey() => _secureStorage.read(key: _phoneCodeKey);

  Future<void> saveUserToken(String value) =>
      _secureStorage.write(key: _tokenKey, value: value);

  Future<void> saveUserId(String? value) =>
      _secureStorage.write(key: _idKey, value: value);

  Future<void> savePhotoUrl(String? value) =>
      _secureStorage.write(key: _avatarUrlKey, value: value);

  Future<void> savePhoneCode(String? value) =>
      _secureStorage.write(key: _phoneCodeKey, value: value);

  Future<void> saveUserPhone({String? phoneNumber}) => Future.wait([
        _secureStorage.write(
          key: _phoneKey,
          value: phoneNumber,
        ),
      ]);
}
