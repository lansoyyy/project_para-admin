import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_para_admin/utils/colors.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    getAllDrivers();
  }

  var hasLoaded = false;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.4803, 124.6498),
    zoom: 13,
  );

  GoogleMapController? mapController;

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? GoogleMap(
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            buildingsEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: markers,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              setState(() {
                mapController = controller;
              });
            },
          )
        : const Center(
            child: SpinKitPulse(
              color: grey,
            ),
          );
  }

  getAllDrivers() async {
    FirebaseFirestore.instance
        .collection('Drivers')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        setState(() {
          markers.add(
            Marker(
              infoWindow: InfoWindow(
                title: doc['name'],
                snippet: doc['isActive'] == true ? 'Active' : 'Inactive',
              ),
              markerId: MarkerId(doc['name']),
              position: LatLng(doc['location']['lat'], doc['location']['long']),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
        });
      }
    });

    setState(() {
      hasLoaded = true;
    });
  }
}
