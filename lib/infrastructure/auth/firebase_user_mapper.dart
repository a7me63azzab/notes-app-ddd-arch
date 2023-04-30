import 'package:ddd_note_app/domain/auth/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/auth/user.dart' as current_user;

extension FirebaseUserDomainX on User {
  current_user.User toDomain() {
    return current_user.User(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
