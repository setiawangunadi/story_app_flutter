part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetListStory extends HomeEvent {
  final int location;
  final int page;

  GetListStory({required this.location, required this.page});
}

class DoLogout extends HomeEvent {}
