import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/config/app_colors/app_colors.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/core/web_services/api_client.dart';
import 'package:instagram_clone_app/core/web_services/auth_service.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/repository/auth/auth_repository.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:instagram_clone_app/firebase_options.dart';
import 'package:instagram_clone_app/presentation/auth/cubit/cubit/auth_cubit.dart';
import 'package:instagram_clone_app/presentation/auth/ui/login_screen.dart';
import 'package:instagram_clone_app/presentation/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/profile/profile_cubit.dart';
import 'package:instagram_clone_app/presentation/profile/ui/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.cachIntialization();

  await DioHelper.initDioHelper();
  await Supabase.initialize(
    url: 'https://icrbvpqtwskkgenybdyk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImljcmJ2cHF0d3Nra2dlbnliZHlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU3Njg4NjMsImV4cCI6MjA1MTM0NDg2M30.CEz89O6ymId2QogCvTQMBFC46yzl6rjhOBm4DJbug4o',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepository(AuthService())),
        ),
        BlocProvider(
          create: (context) => EditProfileCubit(UserRepository(UserService())),
        ),
           BlocProvider(
          create: (context) => ProfileCubit(UserRepository(UserService())),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 944),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: scaffoldBackground,
            colorScheme: ColorScheme.light(
              primary: iconPrimary
            ),
                 textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textPrimary), // Default for large text
          bodyMedium: TextStyle(color: textPrimary), // Default for medium text
          bodySmall: TextStyle(color: textPrimary), // Default for small text
        ),
        primaryTextTheme: const TextTheme(
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textPrimary),
          bodySmall: TextStyle(color: textPrimary),
        ),
          ),
          debugShowCheckedModeBanner: false,
          home: CacheHelper.getData(key: "uId") == null
              ? LoginScreen()
              : ProfileScreen(),
        ),
      ),
    );
  }
}
