import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/shared_widgets/custom_button.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';
import 'package:instagram_clone_app/presentation/auth/cubit/cubit/auth_cubit.dart';
import 'package:instagram_clone_app/presentation/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
        TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding:  const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/instagram_logo_text_white.png"),
            const VerticalSpacer(size: 20),
            const CustomTextField(labelText: "Email"),
           const VerticalSpacer(
              size: 20,
            ),
            const CustomTextField(
              labelText: "Password",
            ),
         const   VerticalSpacer(
              size: 20,
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                }
              },
              builder: (context, state) {
                  var cubit = AuthCubit.get(context);
                return CustomButton(text: "Login", onPressed: () {
                  cubit.signUpEmailPassword(
                      email: _emailController.text,
                      password: _passwordController.text
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
