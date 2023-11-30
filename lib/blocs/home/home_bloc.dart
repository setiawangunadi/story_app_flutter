import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:story_app/config/data/local/shared_prefs_storage.dart';
import 'package:story_app/config/models/get_stories_response_model.dart';
import 'package:story_app/config/repositories/story_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StoryRepository storyRepository = StoryRepository();

  HomeBloc() : super(HomeInitial()) {
    on<GetListStory>(getListStory);
    on<DoLogout>(doLogout);
  }

  Future<void> getListStory(
    GetListStory event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(OnLoadingHome());
      final response = await storyRepository.getListStory(page: event.page, size: 10);
      if (response.statusCode == 200) {
        GetStoriesResponseModel data =
            GetStoriesResponseModel.fromJson(response.data);
        if (data.error == false) {
          int page = event.page + 1;
          emit(OnSuccessHome(data: data, totalPage: page));
        }
      }
    } catch (e) {
      emit(OnFailedHome(message: e.toString()));
    }
  }

  Future<void> doLogout(
    DoLogout event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(OnLoadingHome());
      await SharedPrefsStorage.clearAll();
      emit(OnSuccessLogout());
    } catch (e) {
      emit(OnFailedHome(message: e.toString()));
    }
  }
}
