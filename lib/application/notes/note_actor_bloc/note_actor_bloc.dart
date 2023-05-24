import 'package:dartz/dartz.dart';
import 'package:ddd_note_app/domain/notes/i_note_repository.dart';
import 'package:ddd_note_app/domain/notes/note.dart';
import 'package:ddd_note_app/domain/notes/note_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const _Initial()) {
    on<NoteActorEvent>(_mapEventsToStates);
  }

  Future<void> _mapEventsToStates(
      NoteActorEvent event, Emitter<NoteActorState> emit) async {
    await event.map(deleted: (_Deleted e) async {
      emit(const NoteActorState.actionInProgress());
      final Either<NoteFailure, Unit> result =
          await _noteRepository.delete(e.note);

      result.fold(
        (f) => emit(NoteActorState.deleteFailure(f)),
        (_) => emit(const NoteActorState.deleteSuccess()),
      );
    });
  }
}
