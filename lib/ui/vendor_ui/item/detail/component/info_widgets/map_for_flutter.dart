import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/config/route/route_paths.dart';
import 'package:psxmpc/core/vendor/constant/ps_constants.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/intent_holder/map_pin_intent_holder.dart';

import '../../../../../../../core/vendor/provider/entry/item_entry_provider.dart';
import '../../../../../../core/vendor/provider/product/product_provider.dart';
import '../../../../../../core/vendor/viewobject/product.dart';

class MapForFlutter extends StatefulWidget {
  const MapForFlutter();

  @override
  State<MapForFlutter> createState() => _MapForFlutterState();
}

class _MapForFlutterState extends State<MapForFlutter> {
  late ItemEntryProvider provider;
  double zoom = 16.0;
  late Product product;
  late double lat;
  late double lng;
  @override
  Widget build(BuildContext context) {
    final ItemDetailProvider itemDetailProvider =
        Provider.of<ItemDetailProvider>(context);
    product = itemDetailProvider.product; 
    lat = double.tryParse(product.lat ?? '0.0') ?? 0.0;
    lng = double.tryParse(product.lng ?? '0.0') ?? 0.0;
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
          center:LatLng(lat, lng),
          zoom: zoom, //10.0,
          onTap: (dynamic tapPosition, LatLng latLngr) async {
            onhandleTap();
          }),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(markers: <Marker>[
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(lat, lng),
            builder: (BuildContext ctx) => Container(
              child: IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
                iconSize: 45,
                onPressed: () {
                  onhandleTap();
                },
              ),
            ),
          )
        ])
      ],
    );
  }

  Future<void> onhandleTap() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.VIEW_MAP,
            mapLat: lat.toString(),
            mapLng: lng.toString()));
  }
}
