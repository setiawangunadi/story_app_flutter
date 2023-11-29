import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;

class PlaceMarkWidget extends StatelessWidget {
  const PlaceMarkWidget({
    super.key,
    required this.placeMark,
  });

  final geo.Placemark placeMark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placeMark.street!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.postalCode}, ${placeMark.country}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
