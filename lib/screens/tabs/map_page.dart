import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_para_admin/utils/colors.dart';
import 'package:project_para_admin/widgets/button_widget.dart';

import '../home_screen.dart';

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
    target: LatLng(15.907851, 120.573399),
    zoom: 13,
  );

  GoogleMapController? mapController;

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? Stack(
            children: [
              GoogleMap(
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: ButtonWidget(
                      height: 35,
                      width: 150,
                      fontSize: 12,
                      opacity: 1,
                      color: Colors.green,
                      label: 'Refresh',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
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
