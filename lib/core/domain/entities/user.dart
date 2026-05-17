import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String username,
    required String displayName,
    required String email,
  }) = _User;

  factory User.fromJson(dynamic json) => _$UserFromJson(json);
}
