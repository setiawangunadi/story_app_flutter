part of 'add_story_bloc.dart';

@immutable
abstract class AddStoryEvent {}

class DoAddStory extends AddStoryEvent {
  final String description;
  final dynamic bytes;
  final String filename;
  final String filePath;
  final dynamic lat;
  final dynamic lon;

  DoAddStory({
    required this.description,
    required this.bytes,
    required this.filename,
    required this.filePath,
    this.lat,
    this.lon,
  });
}

class SetImageFileGallery extends AddStoryEvent {
  final XFile value;

  SetImageFileGallery({required this.value});
}

class SetImageFileCamera extends AddStoryEvent {
  final XFile value;

  SetImageFileCamera({required this.value});
}
