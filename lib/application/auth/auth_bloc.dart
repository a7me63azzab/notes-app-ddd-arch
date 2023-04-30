import 'package:ddd_note_app/domain/auth/i_auth_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;
  AuthBloc(this._authFacade) : super(const Initial()) {
    on<AuthEvent>(_mapEventsToStates);
  }

  Future<void> _mapEventsToStates(
      AuthEvent event, Emitter<AuthState> emit) async {
    await event.map(
      authCheckRequested: (e) {
        final userOption = _authFacade.getSignedInUser();
        emit(userOption.fold(
          () => const Unauthenticated(),
          (_) => const Authenticated(),
        ));
      },
      signOut: (e) async {
        await _authFacade.signOut();
        emit(const Unauthenticated());
      },
    );
  }
}
