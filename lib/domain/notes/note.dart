import 'package:dartz/dartz.dart';
import 'package:ddd_note_app/domain/auth/value_objects.dart';
import 'package:ddd_note_app/domain/core/failures.dart';
import 'package:ddd_note_app/domain/notes/todo_item.dart';
import 'package:ddd_note_app/domain/notes/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();
  const factory Note({
    required UniqueId id,
    required NoteBody body,
    required NoteColor color,
    required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(''),
        color: NoteColor(NoteColor.predefinedColors[0]),
        todos: List3(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              .map((todoItem) => todoItem.failureOption)
              .filter((o) => o.isSome())
              .getOrElse(0, (_) => none())
              .fold(() => right(unit), (f) => left(f)),
        )
        .fold((l) => some(l), (_) => none());
  }
}

/**
 This way, the fold method allows you to handle both success and failure cases of 
        an Either type in a concise and readable manner. 
 **/
