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
}
