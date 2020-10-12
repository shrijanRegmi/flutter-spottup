import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';

class VehicleProvider {
  final Vehicle vehicle;
  final AppUser appUser;
  VehicleProvider({this.vehicle, this.appUser});

  final _ref = Firestore.instance;

  // publish vehicle
  Future publishVehicle() async {
    try {
      final _vehicleRef = _ref.collection('vehicles').document();
      vehicle.id = _vehicleRef.documentID;
      await _vehicleRef.setData(vehicle.toJson());
      print('Success: Publishing vehicle ${vehicle.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Publishing vehicle ${vehicle.id}');
      return null;
    }
  }

  // vehicles list from firestore
  List<Vehicle> _vehiclesFromFirestore(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return Vehicle.fromJson(docSnap.data);
    }).toList();
  }

  // stream of vehicles owned by owner
  Stream<List<Vehicle>> get myVehicles {
    return _ref
        .collection('vehicles')
        .limit(50)
        .where('owner_id', isEqualTo: appUser.uid)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(_vehiclesFromFirestore);
  }
}
