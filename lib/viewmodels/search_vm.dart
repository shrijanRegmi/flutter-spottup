import 'package:flutter/material.dart';
import 'package:motel/views/screens/home/search_result_screen.dart';

class SearchVm extends ChangeNotifier {
  final BuildContext context;
  SearchVm({@required this.context});

  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchResultController = TextEditingController();


  TextEditingController get searchController => _searchController;
  TextEditingController get searchResultController => _searchResultController;

  // navigate to result screen when search btn is pressed
  navigateToResultScreen() {
    final _city = _searchController.text.trim();
    if (_city != '') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(_city),
        ),
      );
    }
  }
}
