import 'package:auto_route/auto_route.dart';
import 'package:ddd_note_app/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:ddd_note_app/injection.dart';
import 'package:ddd_note_app/presentation/auth/sign_in/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SingInPage extends StatelessWidget {
  const SingInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("SignIn"),
      ),
      body: BlocProvider(
        create: (context) => getIt<SignInFormBloc>(),
        child: const SignInForm(),
      ),
    );
  }
}
