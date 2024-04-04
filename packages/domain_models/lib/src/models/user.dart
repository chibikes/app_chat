import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final String userId;

  const AppUser({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.avatarUrl = '',
    this.userId = '',
  });

  static AppUser fromJson(Map<String, dynamic> json) {
    return AppUser(
      fullName: json['data']['full_name'],
      email: json['data']['email'],
      phoneNumber: json['data']['phone_number'],
      avatarUrl: json['data']['avatarUrl'],
    );
  }

  AppUser copyWith(
      {String? fullName,
      String? userId,
      String? phoneNumber,
      String? avatarUrl,
      String? email}) {
    return AppUser(
      fullName: fullName ?? this.fullName,
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [fullName, email, phoneNumber, avatarUrl, userId];
}

class UnverifiedUser extends AppUser {
  final String name;
  final String id;
  final String avatar;
  final String phoneNumber;
  final String email;
  const UnverifiedUser({
    this.name = '',
    this.id = '',
    this.avatar = '',
    this.phoneNumber = '',
    this.email = '',
  }) : super(
            fullName: name,
            avatarUrl: avatar,
            userId: id,
            phoneNumber: phoneNumber);

  @override
  AppUser copyWith(
      {String? fullName,
      String? userId,
      String? phoneNumber,
      String? avatarUrl,
      String? email}) {
    return UnverifiedUser(
      name: fullName ?? this.fullName,
      id: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
    );
  }
}
