import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/config/models/add_story_response_model.dart';
import 'package:story_app/config/repositories/story_repository.dart';

part 'add_story_event.dart';
part 'add_story_state.dart';

class AddStoryBloc extends Bloc<AddStoryEvent, AddStoryState> {
  final StoryRepository storyRepository = StoryRepository();

  AddStoryBloc() : super(AddStoryInitial()) {
    on<DoAddStory>(doAddStory);
    on<SetImageFileCamera>(setImageFileCamera);
    on<SetImageFileGallery>(setImageFileGallery);
  }

  Future<void> doAddStory(
    DoAddStory event,
    Emitter<AddStoryState> emit,
  ) async {
    try {
      emit(OnLoadingAddStory());
      debugPrint("ON CLICK UPLOAD");
      final response = await storyRepository.doAddStory(
        description: event.description,
        imagePath: event.filePath,
        imageName: event.filename,
        longitude: event.lon,
        latitude: event.lat,
      );
      AddStoryResponseModel data =
          AddStoryResponseModel.fromJson(response.data);
      if (data.error == false) {
        emit(OnSuccessAddStory(data: data));
      }

      if (data.error == true) {
        emit(OnFailedAddStory(message: data.message ?? ""));
      }
    } catch (e) {
      emit(OnFailedAddStory(message: e.toString()));
    }
  }

  Future<void> setImageFileCamera(
    SetImageFileCamera event,
    Emitter<AddStoryState> emit,
  ) async {
    try {
      emit(OnLoadingAddStory());
      emit(GetFileImageCamera(value: event.value));
    } catch (e) {
      emit(OnFailedAddStory(message: e.toString()));
    }
  }

  Future<void> setImageFileGallery(
    SetImageFileGallery event,
    Emitter<AddStoryState> emit,
  ) async {
    try {
      emit(OnLoadingAddStory());
      emit(GetFileImageCamera(value: event.value));
    } catch (e) {
      emit(OnFailedAddStory(message: e.toString()));
    }
  }
}
