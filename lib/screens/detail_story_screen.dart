import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/blocs/detail_story/detail_story_bloc.dart';

class DetailStoryScreen extends StatefulWidget {
  final String id;

  const DetailStoryScreen({super.key, required this.id});

  @override
  State<DetailStoryScreen> createState() => _DetailStoryScreenState();
}

class _DetailStoryScreenState extends State<DetailStoryScreen> {
  late DetailStoryBloc detailStoryBloc;
  late GoogleMapController mapController;

  @override
  void initState() {
    detailStoryBloc = BlocProvider.of<DetailStoryBloc>(context);
    detailStoryBloc.add(GetDetailStory(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailStoryBloc, DetailStoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Detail Story"),
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                if (state is OnSuccessDetailStory)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRect(
                            child: Image.network(
                              state.data.story?.photoUrl ?? "",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.data.story?.name ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                            Text(
                              state.data.story?.description ?? "",
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            padding: const EdgeInsets.all(16.0),
                            child: GoogleMap(
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              markers: {
                                Marker(
                                  markerId:
                                      MarkerId(state.data.story?.id ?? ""),
                                  position: LatLng(
                                    state.data.story?.lat ?? -6.8957473,
                                    state.data.story?.lon ?? 107.6337669,
                                  ),
                                  onTap: () {
                                    mapController.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                          LatLng(
                                            state.data.story?.lat ?? -6.8957473,
                                            state.data.story?.lon ??
                                                107.6337669,
                                          ),
                                          18),
                                    );
                                  },
                                )
                              },
                              initialCameraPosition: CameraPosition(
                                zoom: 18,
                                target: LatLng(
                                  state.data.story?.lat ?? -6.8957473,
                                  state.data.story?.lon ?? 107.6337669,
                                ),
                              ),
                              onMapCreated: (controller) {
                                setState(() {
                                  mapController = controller;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Column(
                              children: [
                                FloatingActionButton.small(
                                  heroTag: "zoom-in",
                                  onPressed: () {
                                    mapController.animateCamera(
                                      CameraUpdate.zoomIn(),
                                    );
                                  },
                                  child: const Icon(Icons.add),
                                ),
                                FloatingActionButton.small(
                                  heroTag: "zoom-out",
                                  onPressed: () {
                                    mapController.animateCamera(
                                      CameraUpdate.zoomOut(),
                                    );
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
