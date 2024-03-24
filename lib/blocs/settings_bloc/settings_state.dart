import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isDarkTheme;

  const SettingsState({this.isDarkTheme = false});

  @override
  List<Object?> get props => [
        isDarkTheme,
      ];
}
