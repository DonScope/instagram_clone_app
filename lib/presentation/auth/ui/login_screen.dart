
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/config/app_colors/app_colors.dart';
import 'package:instagram_clone_app/core/helpers/navigation_helper.dart';
import 'package:instagram_clone_app/shared_widgets/custom_button.dart';
import 'package:instagram_clone_app/shared_widgets/navigation_bar_screen.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';
import 'package:instagram_clone_app/presentation/auth/cubit/cubit/auth_cubit.dart';
import 'package:instagram_clone_app/presentation/auth/widgets/custom_text_form_field.dart';

import '../../../core/utils/validators.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier<bool>(true);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 244.w,
                  height: 120.h,
                  child: Image.asset("assets/instagram_logo_text_black.png")),
              const VerticalSpacer(size: 20),
              CustomTextField(
                labelText: "email".tr(),
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
                  labelText: "password".tr(),
                  controller: _passwordController,
                  obscureText: _obscureTextNotifier.value,
                  validator: Validators.validatePassword,
                  ic: IconButton(
                      onPressed: () {
                        _obscureTextNotifier.value = !_obscureTextNotifier.value;
                      },
                      icon: Icon(_obscureTextNotifier.value
                          ? Icons.visibility_off
                          : Icons.visibility)),
                );
     }   ),
              const VerticalSpacer(
                size: 20,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is LoginLoading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  } else if (state is LoginSuccess)  {
                    Navigator.of(context, rootNavigator: true).pop();
                    // NAVIGATE TO HOME SCREEN
                    NavigationHelper.goOffAll(context, NavigationBarScreeen());
                  } else if (state is LoginError) {
                    Navigator.of(context, rootNavigator: true).pop();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('login_failed').tr(),
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
                      text: "log_in".tr(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.signInEmailPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                        }
                      });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("dont_have_account".tr()),
                  TextButton(
                    onPressed: () {
                      NavigationHelper.goTo(context, const RegisterScreen());
                    },
                    child:  Text(
                      "register".tr(),
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
    );
  }
}
