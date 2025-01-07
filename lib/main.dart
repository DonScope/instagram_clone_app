import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/core/web_services/api_client.dart';
import 'package:instagram_clone_app/core/web_services/auth_service.dart';
import 'package:instagram_clone_app/firebase_options.dart';
import 'package:instagram_clone_app/presentation/auth/cubit/cubit/auth_cubit.dart';
import 'package:instagram_clone_app/presentation/auth/ui/login_screen.dart';
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
          create: (context) => AuthCubit(AuthService()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
               minTextAdapt: true,
          splitScreenMode: true,
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const LoginScreen()
            ),
      ),
    );
  }
}