import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ddd_note_app/domain/notes/i_note_repository.dart';
import 'package:ddd_note_app/domain/notes/note.dart';
import 'package:ddd_note_app/domain/notes/note_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  NoteWatcherBloc(this._noteRepository) : super(const _Initial()) {
    on<NoteWatcherEvent>(_mapEventsToStates);
  }

  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  Future<void> _mapEventsToStates(
      NoteWatcherEvent event, Emitter<NoteWatcherState> emit) async {
    event.map(
      watchAllStarted: (e) async* {
        emit(const NoteWatcherState.loadInProgress());
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription = _noteRepository.watchAll().listen(
              (failureOrNotes) =>
                  add(NoteWatcherEvent.notesReceived(failureOrNotes)),
            );
      },
      watchUncompletedStarted: (e) async {
        emit(const NoteWatcherState.loadInProgress());
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription = _noteRepository.watchUnCompleted().listen(
              (failureOrNotes) =>
                  add(NoteWatcherEvent.notesReceived(failureOrNotes)),
            );
      },
      notesReceived: (e) async* {
        yield e.failureOrNotes.fold(
          (f) => NoteWatcherState.loadFailure(f),
          (notes) => NoteWatcherState.loadSuccess(notes),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
