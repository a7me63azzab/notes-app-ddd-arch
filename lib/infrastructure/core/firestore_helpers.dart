import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ddd_note_app/domain/auth/i_auth_facade.dart';
import 'package:ddd_note_app/domain/core/errors.dart';
import 'package:ddd_note_app/injection.dart';

extension Firestorex on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(
      () => throw NotAuthenticatedError(),
    );

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
