import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../map_utils/states/app_state.dart';

import '../global/global.dart';

class CurrentRideTabPage extends StatefulWidget {
  const CurrentRideTabPage({Key? key}) : super(key: key);

  @override
  State<CurrentRideTabPage> createState() => _CurrentRideTabPageState();
}

class _CurrentRideTabPageState extends State<CurrentRideTabPage> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppState(),
        )
      ],
      child: RouteDetails(),
    );
  }
}

class RouteDetails extends StatefulWidget {
  const RouteDetails({Key? key}) : super(key: key);

  @override
  State<RouteDetails> createState() => _RouteDetailsState();
}

class _RouteDetailsState extends State<RouteDetails> {
  Set<Polyline> _polyLines = {};
  bool isLoading = true;
  List<LatLng> latLngList = [];

  Future<void> getRoute() async {
    setState(() {
      isLoading = true;
    });
    if (currentUid != null) {
      await getRouteDetails(currentUid);
    } else {
      await getRouteDetails(currentGUid);
    }
    List latLngSerialized = routedata!['route'];

    for (var i = 0; i < latLngSerialized.length; i++) {
      if (i % 2 == 0) {
        latLngList.add(LatLng(latLngSerialized[i], latLngSerialized[i + 1]));
      }
    }

    _polyLines.add(Polyline(
        polylineId: PolylineId('567uid'),
        width: 5,
        color: Colors.blue,
        points: latLngList));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRoute();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    var textstyle = TextStyle(
      fontSize: 16.0,
    );

    var boxDecoration = BoxDecoration(
      color: Colors.green[50],
      border: Border.all(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        new BoxShadow(
            color: Colors.grey,
            offset: new Offset(2.0, 2.0),
            blurRadius: 2.0,
            spreadRadius: 1.0),
      ],
    );

    return !isLoading
        ? Stack(
            children: [
              Text('To ' + routedata!['to']),
              Text('Status ' + routedata!['status']),
              Text('From ' + routedata!['from']),
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: appState.initialPosition!, zoom: 10.0),
                onMapCreated: appState.onCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                polylines: _polyLines,
              ),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  decoration: boxDecoration,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text('Starting from  : ' + routedata!['from'],
                      style: textstyle),
                ),
              ),
              Positioned(
                top: 70,
                left: 20,
                right: 20,
                child: Container(
                  decoration: boxDecoration,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text('Destination  : ' + routedata!['to'],
                      style: textstyle),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  decoration: boxDecoration,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text('Status  : ' + routedata!['status'],
                      style: textstyle),
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
