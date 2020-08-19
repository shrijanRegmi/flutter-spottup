import 'package:flutter/material.dart';
import 'package:motel/viewmodels/search_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/search_widgets/search_result_list.dart';

class SearchResultScreen extends StatelessWidget {
  final String city;
  SearchResultScreen(this.city);

  @override
  Widget build(BuildContext context) {
    return VmProvider<SearchVm>(
      vm: SearchVm(context: context),
      onInit: (vm) {
        vm.searchResultController.text = city;
      },
      builder: (context, vm, appUser) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Search Result',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    _searchBuilder(context, vm),
                    SearchResultList(vm.searchResultController.text.trim()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: vm.searchResultController,
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
              onPressed: null,
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
