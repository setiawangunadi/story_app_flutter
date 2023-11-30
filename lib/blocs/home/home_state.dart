part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class OnLoadingHome extends HomeState {}

class OnSuccessHome extends HomeState {
  final GetStoriesResponseModel data;
  final int totalPage;

  OnSuccessHome({required this.data, required this.totalPage});
}

class OnSuccessLogout extends HomeState {}

class OnFailedHome extends HomeState {
  final String message;
  final int? statusCode;

  OnFailedHome({required this.message, this.statusCode});
}
