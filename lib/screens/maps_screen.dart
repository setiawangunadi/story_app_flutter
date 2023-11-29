import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapsScreen extends StatefulWidget {
  final Function(bool, LatLng, String) onTappedLocation;

  const MapsScreen({super.key, required this.onTappedLocation});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  final Set<Marker> markers = {};
  LatLng locationSelected = const LatLng(-6.8957473, 107.6337669);
  String? infoLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Lokasi"),
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
            onMapCreated: (controller) {
              final marker = Marker(
                markerId: const MarkerId("source"),
                position: dicodingOffice,
              );
              setState(() {
                mapController = controller;
                markers.add(marker);
              });
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
          )
        ],
      ),
    );
  }

  void defineMarker(LatLng latLng) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
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
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    defineMarker(latLng);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    defineMarker(latLng);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    setState(() {
      locationSelected = latLng;
      infoLocation = info[0].name;
    });

    debugPrint("INFO LOCATION UPDATE : $infoLocation");

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
