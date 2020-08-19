import 'package:flutter/material.dart';
import 'package:motel/viewmodels/search_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/screens/home/search_result_screen.dart';
import 'package:motel/views/widgets/search_widgets/hotel_types_list.dart';
import 'package:motel/views/widgets/search_widgets/last_searches_list.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VmProvider<SearchVm>(
      vm: SearchVm(context: context),
      builder: (context, vm, appUser) {
        return Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      _appbarBuilder(context),
                      _searchTextBuilder(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _searchBuilder(context, vm),
                      SizedBox(
                        height: 20.0,
                      ),
                      HotelTypesList(),
                      SizedBox(
                        height: 20.0,
                      ),
                      LastSearchesList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _appbarBuilder(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _searchTextBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Search',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _searchBuilder(BuildContext context, SearchVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3.0, 3.0),
                    blurRadius: 10.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: vm.searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Where are you going?',
                    contentPadding: const EdgeInsets.only(top: 15.0),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff45ad90),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 45.0,
            height: 45.0,
            child: FloatingActionButton(
              onPressed: vm.navigateToResultScreen,
              backgroundColor: Color(0xff45ad90),
              child: Icon(
                Icons.search,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
