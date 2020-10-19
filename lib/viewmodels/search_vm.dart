import 'package:flutter/material.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/services/firestore/tour_provider.dart';
import 'package:motel/services/firestore/vehicle_provider.dart';
import 'package:motel/views/screens/home/search_result_screen.dart';

class SearchVm extends ChangeNotifier {
  final BuildContext context;
  SearchVm({@required this.context});

  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchResultController = TextEditingController();
  String _selectedSearchType = 'Hotels';

  List<String> searchTypes = [
    'Hotels',
    'Tours',
    'Bus/Car',
  ];
  TextEditingController get searchController => _searchController;
  TextEditingController get searchResultController => _searchResultController;
  String get selectedSearchType => _selectedSearchType;

  // navigate to result screen when search btn is pressed
  navigateToResultScreen() {
    final _city = _searchController.text.trim();
    final _searchType = _selectedSearchType;

    if (_city != '') {
      Stream _stream;
      AccountType _type;

      switch (_searchType) {
        case 'Hotels':
          _stream = HotelProvider(
            searchKey: _city.substring(0, 1).toUpperCase(),
          ).searchedHotelsFromKey;
          _type = AccountType.hotelPartner;
          break;
        case 'Tours':
          _stream = TourProvider(
            searchKey: _city.substring(0, 1).toUpperCase(),
          ).searchedToursFromKey;
          _type = AccountType.tourPartner;
          break;
        case 'Bus/Car':
          _stream = VehicleProvider(
            searchKey: _city.substring(0, 1).toUpperCase(),
          ).searchedVehiclesFromKey;
          _type = AccountType.vehiclePartner;
          break;
        default:
          _stream = HotelProvider(
            searchKey: _city.substring(0, 1).toUpperCase(),
          ).searchedHotelsFromKey;
          _type = AccountType.hotelPartner;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(_stream, _city, _type),
        ),
      );
    }
  }

  // update value of selected search type
  updateSelectedSearchType(final String newVal) {
    _selectedSearchType = newVal;
    notifyListeners();
  }
}
