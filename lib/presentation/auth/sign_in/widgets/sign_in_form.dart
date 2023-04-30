import 'package:another_flushbar/flushbar.dart';
import 'package:ddd_note_app/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () => {},
          (either) => either.fold(
            (failure) {
              // show the sneakbar
              Flushbar(
                // title: "Error",
                icon: const Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
                message: failure.map(
                  cancelledByUser: (_) => "Cancelled",
                  serverError: (_) => "Server Error",
                  emailAlreadyInUse: (_) => "Email Already In Use",
                  invalidEmailAndPasswordCombination: (_) =>
                      "Invalid email and password combination",
                ),
                duration: const Duration(seconds: 3),
              ).show(context);
            },
            (_) {
              // Navigate to another page
            },
          ),
        );
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessages
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                const Text(
                  "📝",
                  style: TextStyle(
                    fontSize: 130,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    label: Text('Email'),
                  ),
                  autocorrect: false,
                  onChanged: (val) => context.read<SignInFormBloc>().add(
                        SignInFormEvent.emailChanged(val),
                      ),
                  validator: (_) => context
                      .read<SignInFormBloc>()
                      .state
                      .emailAddress
                      .value
                      .fold(
                        (l) => l.maybeMap(
                          invalidEmail: (_) => 'Invalid Email',
                          orElse: () => null,
                        ),
                        (r) => null,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    label: Text('Password'),
                  ),
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (val) => context.read<SignInFormBloc>().add(
                        SignInFormEvent.passwordChanged(val),
                      ),
                  validator: (_) =>
                      context.read<SignInFormBloc>().state.password.value.fold(
                            (l) => l.maybeMap(
                              shortPassword: (_) => 'Short Password',
                              orElse: () => null,
                            ),
                            (r) => null,
                          ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        BlocProvider.of<SignInFormBloc>(context).add(
                            const SignInFormEvent
                                .signInWithEmailAndPasswordPressed());
                      },
                      child: const Text("SIGNIN"),
                    ),
                    TextButton(
                      onPressed: () {
                        // context.select()

                        context.read<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .registerWithEmailAndPasswordPressed(),
                            );
                      },
                      child: const Text("REGISTER"),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<SignInFormBloc>(context)
                        .add(const SignInFormEvent.signInWithGooglePressed());
                  },
                  child: const Text('SIGN IN WITH GOOGLE'),
                ),
                if (state.isSubmitting) ...[
                  const SizedBox(
                    height: 8,
                  ),
                  const LinearProgressIndicator(
                    value: null,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
