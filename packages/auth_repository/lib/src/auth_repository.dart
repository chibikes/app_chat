import 'dart:async';
import 'dart:io';

import 'package:auth_repository/src/user_secure_storage.dart';
import 'package:domain_models/domain_models.dart' as dm_models;
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  dm_models.AppUser _user = const dm_models.UnverifiedUser();
  final UserSecureStorage _secureStorage = const UserSecureStorage();
  final BehaviorSubject<dm_models.AppUser> _userSubject = BehaviorSubject();
  final _usersTable = 'users';
  String _fcmToken = '';
  String _phoneCode = '';

  StreamSubscription? _firebaseUserSub, _supabaseUserSub;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Future<void> signIn(AuthCredential authCredential,
      {required String email, required String password}) async {
    await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);
    await _firebaseAuth.signInWithCredential(authCredential);
    await updateUserInfo();
  }

  Future<void> updateUserInfo() async {
    try {
      if (_phoneCode.isEmpty) {
        _phoneCode = await _secureStorage.getPhoneCodeKey() ?? '';
      }
      final data = await Supabase.instance.client.from(_usersTable).upsert({
        'user_id': _user.userId.isNotEmpty
            ? _user.userId
            : Supabase.instance.client.auth.currentUser?.id,
        'phone_number': _firebaseAuth.currentUser?.phoneNumber,
        'fcm_token': _fcmToken,
        'phone_code': _phoneCode
      }, onConflict: 'user_id').select();

      _user = _user.copyWith(avatarUrl: data.first['avatar_url'] ?? '');
      _secureStorage.insertUserInfo(
          phoneNumber: _firebaseAuth.currentUser?.phoneNumber,
          id: Supabase.instance.client.auth.currentUser?.id,
          avatarUrl: data.first['avatar_url']);
      _userSubject.add(_user);
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

  Future<void> signUpToSupaBase(
      {required String email, required String password}) async {
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('could not sign up $e');
      try {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        print('Error trying to sign in $e');
      }
    }
  }

  void setFcmToken(String token) {
    _fcmToken = token;
  }

  void setPhoneCode(String phoneCode) {
    _phoneCode = phoneCode;
    _secureStorage.savePhoneCode(phoneCode);
  }

  Future<void> logOut() async {
    Future.wait([
      _secureStorage.deleteUserInfo(),
    ]);
    await _firebaseAuth.signOut();
    await Supabase.instance.client.auth.signOut();
  }

  Stream<void> getFirebaseUser() {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        _user = dm_models.UnverifiedUser(
            avatar: _user.avatarUrl,
            id: _user.userId,
            phoneNumber: _user.phoneNumber,
            name: _user.fullName);
      } else {
        if (_user.phoneNumber.isEmpty) {
          _user = _user.copyWith(phoneNumber: firebaseUser.phoneNumber);
          _secureStorage.saveUserPhone(
            phoneNumber: firebaseUser.phoneNumber,
          );
        }

        if (_user.userId.isEmpty) {
          _secureStorage
              .saveUserId(Supabase.instance.client.auth.currentUser?.id)
              .catchError((e) {
            print('Error trying to save user id: $e');
          });
          _user = _user.copyWith(
              userId: Supabase.instance.client.auth.currentUser?.id);
        }

        _user = dm_models.AppUser(
          userId: _user.userId,
          avatarUrl: _user.avatarUrl,
          phoneNumber: firebaseUser.phoneNumber ?? '',
        );
      }
      _userSubject.add(_user);
    });
  }

  Stream<dm_models.AppUser> getUser() async* {
    // streaming user cred from two sources that's why we need this method. we need firebase for phone auth. supabase
    // phone auth doesn't work well for now

    if (!_userSubject.hasValue) {
      try {
        final userInfo = await Future.wait([
          _secureStorage.getUserName(),
          _secureStorage.getUserId(),
          _secureStorage.getAvatarUrl(),
          _secureStorage.getPhoneNumber(),
        ]);

        _user = (userInfo[1] == null || userInfo[3] == null)
            ? const dm_models.UnverifiedUser()
            : dm_models.AppUser(
                fullName: userInfo[0] ?? '',
                userId: userInfo[1] ?? '',
                avatarUrl: userInfo[2] ?? '',
                phoneNumber: userInfo[3] ?? '',
              );
      } catch (err) {
        print('Error trying to get user $err');
        _user = const dm_models.UnverifiedUser();
      }
      print('user is ${_user.avatarUrl}');
      _userSubject.add(_user);

      _firebaseUserSub ??= getFirebaseUser().listen((event) {});
      _supabaseUserSub ??= getSupaBaseUser().listen((event) {});
    }
    yield* _userSubject.stream.asBroadcastStream();
  }

  Future<void> cancelSubscriptions() async {
    await _firebaseUserSub?.cancel();
    await _supabaseUserSub?.cancel();
  }

  void uploadPhoto(String filePath) async {
    print('filepath is $filePath');

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (filePath.isNotEmpty) {
      var uploadfilePath = '$userId/$userId.jpg';
      try {
        await Supabase.instance.client.storage
            .from('photos')
            .upload(uploadfilePath, File(filePath));
      } catch (e) {
        print('error is $e');
        await Future.delayed(Duration(seconds: 1));
        await Supabase.instance.client.storage
            .from('photos')
            .update(uploadfilePath, File(filePath));
      }

      var photoUrl = await Supabase.instance.client.storage
          .from('photos')
          .getPublicUrl(uploadfilePath);

      print('photourl is $photoUrl');

      await Supabase.instance.client
          .from(_usersTable)
          .update({
            'avatar_url': photoUrl,
          })
          .eq('user_id',
              Supabase.instance.client.auth.currentUser?.id ?? _user.userId)
          .catchError((err) {
            print('Error trying to update user: $err');
          });

      _user = _user.copyWith(avatarUrl: photoUrl);
      _secureStorage.savePhotoUrl(photoUrl).catchError((err) {
        print('Error saving photo');
      });
      _userSubject.add(_user);
    }
  }

  Stream<void> getSupaBaseUser() {
    if (Supabase.instance.client.auth.currentSession != null ||
        Supabase.instance.client.auth.currentUser != null) {
      _secureStorage.saveUserId(
        Supabase.instance.client.auth.currentUser?.id,
      );
      _user =
          _user.copyWith(userId: Supabase.instance.client.auth.currentUser?.id);
      _userSubject.add(_user);
    }
    return Supabase.instance.client.auth.onAuthStateChange.map((data) {
      final authEvent = data.event;
      if (authEvent == AuthChangeEvent.signedOut) {
        if (_firebaseAuth.currentUser == null) {
          _firebaseAuth.signOut();
        }
      } else if (authEvent == AuthChangeEvent.signedIn) {
        if (_user.userId.isEmpty) {
          _secureStorage.saveUserId(
            Supabase.instance.client.auth.currentUser?.id,
          );
          _user = _user.copyWith(
              userId: Supabase.instance.client.auth.currentUser?.id);
          _userSubject.add(_user);
        }
      }
    });
  }

  void updateFCMToken(fcmToken) {
    try {
      Supabase.instance.client
          .from(_usersTable)
          .update({'fcm_token': fcmToken}).eq('user_id',
              Supabase.instance.client.auth.currentUser?.id ?? _user.userId);
    } catch (e) {
      print('Error: couldn\'t update token $e');
      Supabase.instance.log('Error updating fcm token: $e');
    }
  }
}
