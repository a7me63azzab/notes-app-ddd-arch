import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_note_app/domain/notes/i_note_repository.dart';
import 'package:ddd_note_app/domain/notes/note.dart';
import 'package:ddd_note_app/domain/notes/note_failure.dart';
import 'package:ddd_note_app/infrastructure/core/firestore_helpers.dart';
import 'package:ddd_note_app/infrastructure/notes/note_dtos.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepositoryImpl implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepositoryImpl(this._firestore);
  @override
  Future<Either<NoteFailure, Unit>> create(Note note) {
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) {
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) {
    throw UnimplementedError();
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(
              (doc) => NoteDTO.fromFirestore(doc).toDomain(),
            ))
        .map(
          (notes) => right<NoteFailure, KtList<Note>>(notes
              .where(
                (note) =>
                    note.todos.getOrCrash().any((todoItem) => !todoItem.done),
              )
              .toImmutableList()),
        )
        .onErrorReturnWith((error, stackTrace) {
      if (error is PlatformException &&
          error.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUnCompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => right<NoteFailure, KtList<Note>>(
            snapshot.docs
                .map(
                  (doc) => NoteDTO.fromFirestore(doc).toDomain(),
                )
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((error, stackTrace) {
      if (error is PlatformException &&
          error.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }
}
