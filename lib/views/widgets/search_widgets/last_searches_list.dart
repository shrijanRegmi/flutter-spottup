import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/last_search_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/search_widgets/last_searches_item.dart';
import 'package:provider/provider.dart';
import 'package:motel/services/firestore/hotel_provider.dart';

class LastSearchesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<List<LastSearch>>(
        stream: HotelProvider(uid: _appUser.uid).lastSearchList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final _lastSearches = snapshot.data;
            return _lastSearches.isEmpty
                ? Container()
                : Container(
                    child: Column(
                      children: <Widget>[
                        LeftRightText(
                          leftText: 'Last searches',
                          rightText: 'Clear all',
                          requiredIcon: false,
                          onPressIcon: () {
                            UserProvider(uid: _appUser.uid).clearSearch();
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _lastSearchesList(_lastSearches),
                      ],
                    ),
                  );
          }
          return Container();
        });
  }

  Widget _lastSearchesList(final List<LastSearch> _lastSearchesList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        itemCount: _lastSearchesList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          childAspectRatio: 3 / 6.0,
        ),
        itemBuilder: (context, index) {
          return StreamBuilder<Hotel>(
              stream: HotelProvider(hotelRef: _lastSearchesList[index].hotelRef)
                  .hotelFromRef,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: LastSearchesItem(snapshot.data),
                  );
                }
                return Container();
              });
        },
      ),
    );
  }
}
