import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart'; // Import the state file

class ThemeCubit extends Cubit<ThemeState> {
      static ThemeCubit get(context) => BlocProvider.of(context);
  ThemeCubit() : super(LightThemeState()) {
    _loadTheme();
  }

  void toggleTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", isDark);
    emit(isDark ? DarkThemeState() : LightThemeState());
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool("isDark") ?? false;
    emit(isDark ? DarkThemeState() : LightThemeState());
  }
}
