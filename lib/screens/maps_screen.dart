import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:story_app/screens/component/place_mark_widget.dart';

class MapsScreen extends StatefulWidget {
  final Function(bool, LatLng, String) onTappedLocation;

  const MapsScreen({super.key, required this.onTappedLocation});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  geo.Placemark? placemark;
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  final Set<Marker> markers = {};
  LatLng locationSelected = const LatLng(-6.8957473, 107.6337669);
  String? infoLocation;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        widget.onTappedLocation(
          true,
          const LatLng(0.0, 0.0),
          infoLocation ?? "",
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pilih Lokasi"),
          leading: GestureDetector(
            onTap: () => widget.onTappedLocation(
              true,
              const LatLng(0.0, 0.0),
              infoLocation ?? "",
            ),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: markers,
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: dicodingOffice,
              ),
              onMapCreated: (controller) async {
                final info = await geo.placemarkFromCoordinates(
                    dicodingOffice.latitude, dicodingOffice.longitude);
                final place = info[0];
                final street = place.street!;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                setState(() {
                  placemark = place;
                });
                defineMarker(dicodingOffice, street, address);
                setState(() {
                  mapController = controller;
                });
              },
              onLongPress: (LatLng latLng) {
                onLongPressGoogleMap(latLng);
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () {
                  onMyLocationButtonPress();
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => widget.onTappedLocation(
                    true,
                    locationSelected,
                    infoLocation ?? "",
                  ),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  child: const Text(
                    "Pilih Lokasi",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 64,
                right: 16,
                left: 16,
                child: PlaceMarkWidget(
                  placeMark: placemark!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
      locationSelected = latLng;
    });

    defineMarker(latLng, street ?? "", address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street, address);

    debugPrint("INFO LOCATION UPDATE : $infoLocation");
    debugPrint("INFO LOCATION SELECTED : $locationSelected");

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
