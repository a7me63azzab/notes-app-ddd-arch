import 'package:dartz/dartz.dart';
import 'package:ddd_note_app/domain/auth/i_auth_facade.dart';
import 'package:ddd_note_app/domain/auth/value_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/auth/auth_failure.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

typedef AuthAction = Future<Either<AuthFailure, Unit>> Function({
  required EmailAddress emailAddress,
  required Password password,
});

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _iAuthFacade;

  SignInFormBloc(this._iAuthFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>(_mapEventsToStates);
  }

  Future<void> _mapEventsToStates(
      SignInFormEvent events, Emitter<SignInFormState> emit) async {
    await events.map(
      emailChanged: (EmailChanged e) {
        emit(
          state.copyWith(
            emailAddress: EmailAddress(e.emailStr),
            authFailureOrSuccessOption: none(),
          ),
        );
      },
      passwordChanged: (PasswordChanged e) {
        emit(
          state.copyWith(
            password: Password(e.passwordStr),
            authFailureOrSuccessOption: none(),
          ),
        );
      },
      registerWithEmailAndPasswordPressed:
          (RegisterWithEmailAndPasswordPressed e) async {
        await _performActionOnAuthFacadeWithEmailAndPassword(
          emit: emit,
          forwaredCall: _iAuthFacade.registerWithEmailAndPassword,
        );
      },
      signInWithEmailAndPasswordPressed:
          (SignInWithEmailAndPasswordPressed e) async {
        await _performActionOnAuthFacadeWithEmailAndPassword(
          emit: emit,
          forwaredCall: _iAuthFacade.signInWithEmailAndPassword,
        );
      },
      signInWithGooglePressed: (SignInWithGooglePressed e) async {
        emit(
          state.copyWith(
            isSubmitting: true,
            authFailureOrSuccessOption: none(),
          ),
        );

        Either<AuthFailure, Unit> failureOrSuccess =
            await _iAuthFacade.signInWithGoogle();

        emit(
          state.copyWith(
            isSubmitting: false,
            authFailureOrSuccessOption: some(failureOrSuccess),
          ),
        );
      },
    );
  }

  Future _performActionOnAuthFacadeWithEmailAndPassword({
    required Emitter<SignInFormState> emit,
    required AuthAction forwaredCall,
  }) async {
    Either<AuthFailure, Unit>? failureOrSuccess;
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );

      failureOrSuccess = await forwaredCall(
          emailAddress: state.emailAddress, password: state.password);
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        // USE THIS
        ///-  authFailureOrSuccessOption:
        ///-     failureOrSuccess == null ? none() : some(failureOrSuccess),
        // OR, THIS
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }
}
