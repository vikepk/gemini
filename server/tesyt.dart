class HomeMap extends StatefulWidget {
  const HomeMap({Key? key}) : super(key: key);

  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> driverMarkers = <Marker>{};
  final UberService controller = Get.put(UberService());
  late StreamSubscription<QuerySnapshot<Object?>> driversListener;

  @override
  void initState() {
    super.initState();

    controller.loadData().then((value) {
      driversListener = FirebaseFirestore.instance
          .collection('driver_locations')
          .where('status', isEqualTo: true)
          .limit(50)
          .snapshots()
          .listen((QuerySnapshot<Object?> querySnapshot) {
        List<DocumentSnapshot<Object?>> list = querySnapshot.docs;
        driverMarkers.clear();

        for (int i = 0; i < list.length; i++) {
          DocumentSnapshot<Object?> snapshot = list[i];

          driverMarkers.add(
            Marker(
              markerId: MarkerId(snapshot.id),
              position: LatLng(snapshot.get('location').latitude,
                  snapshot.get('location').longitude),
              draggable: false,
              zIndex: 2,
              rotation: snapshot.get('heading'),
              anchor: const Offset(0.5, 0.5),
              icon: snapshot.get("carColor") == 'red'
                  ? BitmapDescriptor.fromBytes(controller.redCar.value!)
                  : BitmapDescriptor.fromBytes(controller.whiteCar.value!),
              onTap: () => Get.bottomSheet(
                DriverBottomSheet(driverId: snapshot.id),
                isScrollControlled: true,
                enableDrag: true,
              ),
            ),
          );
        }
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<LocationProvider>(context).mapReady) {
      return const Center(
        child: Text('Loading assets...'),
      );
    }

    return Obx(() {
      if (!controller.areAssetsReady.value) {
        return Container(
          child: const Center(
            child: Text('Loading assets...'),
          ),
        );
      }

      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: Provider.of<LocationProvider>(context, listen: false).lastLocation!,
          zoom: 16,
        ),
        onMapCreated: (GoogleMapController controller) async {
          controller.setMapStyle(this.controller.mapStyle.value);
          mapController.complete(controller);
        },
        zoomControlsEnabled: false,
        markers: driverMarkers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    driversListener.cancel();
  }
}