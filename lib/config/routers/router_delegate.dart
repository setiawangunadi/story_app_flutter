import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/blocs/add_story/add_story_bloc.dart';
import 'package:story_app/blocs/detail_story/detail_story_bloc.dart';
import 'package:story_app/blocs/home/home_bloc.dart';
import 'package:story_app/blocs/login/login_bloc.dart';
import 'package:story_app/blocs/register/register_bloc.dart';
import 'package:story_app/screens/add_story_screen.dart';
import 'package:story_app/screens/detail_story_screen.dart';
import 'package:story_app/screens/home_screen.dart';
import 'package:story_app/screens/login_screen.dart';
import 'package:story_app/screens/maps_screen.dart';
import 'package:story_app/screens/register_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  bool isClickRegister = false;
  bool isClickLogin = false;
  bool isClickAddStory = false;
  bool isClickDetailStory = false;
  bool isClickMaps = false;
  bool isBackMaps = false;
  String? storyId;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: BlocProvider(
            create: (context) => LoginBloc(),
            child: LoginScreen(
              onTappedRegister: (bool isSelected) {
                isClickRegister = isSelected;
                notifyListeners();
              },
              onTappedLogin: (bool isSelected) {
                isClickLogin = isSelected;
                notifyListeners();
              },
            ),
          ),
        ),
        if (isClickRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: BlocProvider(
              create: (context) => RegisterBloc(),
              child: const RegisterScreen(),
            ),
          ),
        if (isClickLogin == true)
          MaterialPage(
            key: const ValueKey("HomePage"),
            maintainState: false,
            child: BlocProvider(
              create: (context) => HomeBloc(),
              child: HomeScreen(
                onTappedAddStory: (bool isSelected) {
                  isClickAddStory = isSelected;
                  notifyListeners();
                },
                onTappedLogout: (bool isSelected) {
                  isClickLogin = isSelected;
                  notifyListeners();
                },
                onTappedDetailStory: (bool isSelected, String id) {
                  isClickDetailStory = isSelected;
                  storyId = id;
                  notifyListeners();
                },
              ),
            ),
          ),
        if (isClickAddStory == true)
          MaterialPage(
            key: const ValueKey("AddStoryPage"),
            maintainState: false,
            child: BlocProvider(
              create: (context) => AddStoryBloc(),
              child: AddStoryScreen(
                onTappedMaps: (bool isSelected) {
                  isClickMaps = isSelected;
                  notifyListeners();
                },
              ),
            ),
          ),
        if (isClickDetailStory == true)
          MaterialPage(
            key: const ValueKey("DetailStoryPage"),
            maintainState: false,
            child: BlocProvider(
              create: (context) => DetailStoryBloc(),
              child: DetailStoryScreen(id: storyId ?? ''),
            ),
          ),
        if (isClickMaps == true)
          const MaterialPage(
            key: ValueKey("MapsPage"),
            maintainState: false,
            child: MapsScreen(),
          ),
      ],
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        isClickRegister = false;
        isClickAddStory = false;
        isClickDetailStory = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
