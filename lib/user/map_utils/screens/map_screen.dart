// ignore_for_file: prefer_collection_literals, unnecessary_new, unused_local_variable

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:get/state_manager.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/user/global/global.dart';
import '../requests/google_maps_requests.dart';
import '../states/app_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_place/google_place.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String selectedValue = 'car';

  final List<String> items = [
    // Due to Graphhopper account limitations following are not allowed
    // 'hike',
    // 'wheelchair',
    // 'racingbike',
    // 'bike2',
    // 'mtb',
    // 'car4wd',
    // 'motorcycle'

    'foot',
    'car',
    'bike',
  ];

  var googlePlace = GooglePlace("AIzaSyDWXI9gjfdLIDm0j-C61Yx6IMbhPJnk4u4");
  List<AutocompletePrediction> predictions = [];
  TextEditingController _searchtextEditingController =
      new TextEditingController();
  static const kGoogleApiKey = '21f0ccee8ba744d09c0147e76965e3f9';

  late CameraPosition _cameraPosition;
  late String currentDestPlace;

  @override
  void initState() {
    super.initState();
  }

  void autoCompleteSearch(String value) async {
    print(value);
    try {
      var result = await googlePlace.autocomplete.get(value);
      if (result != null && result.predictions != null && mounted) {
        print(result.predictions!.first.description);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    var locationController;
    return Scaffold(
      body: appState.initialPosition != null
          ? Stack(
              children: [
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
                  polylines: appState.polyLines,
                ),

                /* ###### Input Tags  ###### */

                Positioned(
                  top: 50.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.green,
                          offset: Offset(0.1, 0.1),
                          blurRadius: 10,
                          spreadRadius: 0.5)
                    ]),
                    child: TypeAheadField(
                      noItemsFoundBuilder: (context) => const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text('No Item Found'),
                        ),
                      ),
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white,
                        elevation: 4.0,
                      ),
                      debounceDuration: const Duration(milliseconds: 400),
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: appState.locationController,
                          decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(
                              //   3.0,
                              // )),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3.0),
                                ),
                                // borderSide: BorderSide(color: Colors.black)
                              ),
                              hintText: "    Search",
                              contentPadding:
                                  const EdgeInsets.only(top: 4, left: 10),
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search,
                                      color: Colors.grey)),
                              fillColor: Colors.white,
                              filled: true)),
                      suggestionsCallback: (value) {
                        return _handlePressButton(value);
                      },
                      itemBuilder: (context, String suggestion) {
                        return Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.refresh,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  suggestion,
                                  maxLines: 1,
                                  // style: TextStyle(color: Colors.red),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      onSuggestionSelected: (String suggestion) {
                        setState(() {
                          // userSelected = suggestion;
                          appState.locationController.text = suggestion;
                          appState.sendRequest(intendedLocation: suggestion);
                          setState(() {});
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 105.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.green,
                          offset: Offset(0.1, 0.1),
                          blurRadius: 10,
                          spreadRadius: 1)
                    ]),
                    child: TypeAheadField(
                      noItemsFoundBuilder: (context) => const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text('No Item Found'),
                        ),
                      ),
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white,
                        elevation: 4.0,
                      ),
                      debounceDuration: const Duration(milliseconds: 400),
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _searchtextEditingController,
                          decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(
                              //   3.0,
                              // )),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3.0),
                                ),
                                // borderSide: BorderSide(color: Colors.black)
                              ),
                              hintText: "    Search",
                              contentPadding:
                                  const EdgeInsets.only(top: 4, left: 10),
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search,
                                      color: Colors.grey)),
                              fillColor: Colors.white,
                              filled: true)),
                      suggestionsCallback: (value) {
                        return _handlePressButton(value);
                      },
                      itemBuilder: (context, String suggestion) {
                        return Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.refresh,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  suggestion,
                                  maxLines: 1,
                                  // style: TextStyle(color: Colors.red),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      onSuggestionSelected: (String suggestion) {
                        setState(() {
                          // userSelected = suggestion;
                          _searchtextEditingController.text = suggestion;
                          appState.sendRequest(intendedLocation: suggestion);
                          setState(() {
                            currentDestPlace = suggestion;
                          });
                          setState(() {});
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    )),

                /*  Positioned(
                  top: 40,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {},
                    tooltip: "add marker",
                    backgroundColor: Colors.black,
                    child: const Icon(
                      Icons.add_location,
                      color: Colors.white,
                    ),
                  ),
                )
              */
              ],
            )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitRotatingCircle(
                        color: Colors.black,
                        size: 50.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                      visible: appState.locationServiceActive == false,
                      child: Text(
                        "\nPlease enable location services!\n\nAnd Kindly restart the application",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )),
                ],
              ),
            ),
      persistentFooterButtons: [
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  print("PACKAGE");
                  print(appState.polyLines);
                  currentUid != null
                      ? addNewRoute(
                          currentUid,
                          appState.polyLines,
                          appState.locationController.text,
                          _searchtextEditingController.text)
                      : addNewRoute(
                          currentGUid,
                          appState.polyLines,
                          appState.locationController.text,
                          _searchtextEditingController.text);
                },
                child: const Text('Search Rides'),
                style: ButtonStyle()),

            SizedBox(
              width: 10.0,
            ),

            //
            ElevatedButton(
                onPressed: () {
                  print(appState.polyLines);
                  currentUid != null
                      ? addNewRoute(
                          currentUid,
                          appState.polyLines,
                          appState.locationController.text,
                          _searchtextEditingController.text)
                      : addNewRoute(
                          currentGUid,
                          appState.polyLines,
                          appState.locationController.text,
                          _searchtextEditingController.text);
                  //
                },
                child: const Text('Post Ride'),
                style: ButtonStyle()),
            SizedBox(
              width: 10.0,
            ),

            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          onTap: () {
                            print('tapped ' + item);

                            appState.sendRequest(
                                intendedLocation: currentDestPlace,
                                vehicle: item);
                          },
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.yellow,
                iconDisabledColor: Colors.grey,
                buttonHeight: 40,
                buttonWidth: 100,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: Colors.blue,
                ),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.blue,
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-20, 0),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<List<String>> _handlePressButton(value) async {
    print(value);
    print('Captain kirubakaran');
    String url =
        "https://api.geoapify.com/v1/geocode/autocomplete?text=${value}&apiKey=${kGoogleApiKey}";
    print(url);
    Response response = await get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    List placeFormattedList = [];
    List latLngList = [];
    for (var item in values["features"]) {
      latLngList
          .add(LatLng(item["properties"]["lat"], item["properties"]["lon"]));
      placeFormattedList.add(item["properties"]["formatted"]);
    }

    List<String> menuItems = [];

    for (var i = 0; i < placeFormattedList.length; i++) {
      // menuItems.add({"name": placeFormattedList[i], "latlng": latLngList[i]});
      menuItems.add(placeFormattedList[i]);
    }

    return menuItems;

    // setState(() {
    //   _myKey.currentState!.updateItems(menuItems, latLngList);
    // });
  }
}
