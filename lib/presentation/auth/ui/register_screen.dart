import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/core/utils/validators.dart';
import 'package:instagram_clone_app/presentation/auth/ui/login_screen.dart';

import '../../../config/app_colors/app_colors.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../../../shared_widgets/custom_button.dart';
import '../../../shared_widgets/vertical_spacer.dart';
import '../widgets/custom_text_form_field.dart';
import '../cubit/cubit/auth_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier<bool>(true);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                      width: 244.w,
                      height: 120.h,
                      child: Image.asset("assets/instagram_logo_text_black.png")),
                  const VerticalSpacer(
                    size: 20,
                  ),
                  CustomTextField(
                    labelText: "Username",
                    controller: _usernameController,
                    validator: Validators.validateUsername,
                  ),
                  const VerticalSpacer(size: 20),
                  CustomTextField(
                    labelText: "Email",
                    controller: _emailController,
                    validator: Validators.validateEmail,
                  ),
                  const VerticalSpacer(
                    size: 20,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _obscureTextNotifier,
                    builder: (context, value, child) {
                      return CustomTextField(
                        labelText: "Password",
                        controller: _passwordController,
                        obscureText: _obscureTextNotifier.value,
                        validator: Validators.validatePassword,
                        ic: IconButton(
                            onPressed: () {
                              _obscureTextNotifier.value =
                                  !_obscureTextNotifier.value;
                            },
                            icon: Icon(_obscureTextNotifier.value
                                ? Icons.visibility_off
                                : Icons.visibility)),
                      );
                    },
                  ),
                  const VerticalSpacer(
                    size: 20,
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is RegisterLoading) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                      } else if (state is RegisterSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Registration Success!"),
                            backgroundColor: buttonPrimary,
                          ),
                        );
                        Navigator.of(context, rootNavigator: true).pop();
                        // NAVIGATE TO HOME SCREEN
                        // NavigationHelper.goTo(context, const LoginScreen());
                      } else if (state is RegisterError) {
                        Navigator.of(context, rootNavigator: true).pop();
              
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Registration failed'),
                              content: Text(state.error),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      var cubit = AuthCubit.get(context);
                      return CustomButton(
                          text: "Sign up",
                          onPressed: () {
                            if (_formKey.currentState!.validate()){
                                       cubit.signUpEmailPassword(
                                email: _emailController.text,
                                displayName: _usernameController.text,
                                password: _passwordController.text);
                            }
                   
                          });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have an account?"),
                      TextButton(
                        onPressed: () {
                          NavigationHelper.goTo(context, const LoginScreen());
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                              color: textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
