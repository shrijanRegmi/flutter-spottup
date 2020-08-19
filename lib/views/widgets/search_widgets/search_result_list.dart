import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/views/widgets/search_widgets/search_result_list_item.dart';
import 'package:motel/services/firestore/hotel_provider.dart';

class SearchResultList extends StatelessWidget {
  final String city;
  SearchResultList(this.city);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Hotel>>(
      stream: HotelProvider(city: city).searchedHotels,
      builder: (BuildContext context, AsyncSnapshot<List<Hotel>> snapshot) {
        if (snapshot.hasData) {
          final _hotels = snapshot.data;
          final _count = _hotels.length;

          return Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              _countAndFilterBuilder(_count),
              _count == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text('No hotels found in "$city"'),
                    )
                  : _resultListBuilder(_hotels),
            ],
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _countAndFilterBuilder(final int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${count} hotels found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.filter_list,
                    size: 20.0,
                    color: Color(0xff45ad90),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultListBuilder(final List<Hotel> hotels) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        return SearchResultListItem(hotels[index]);
      },
    );
  }
}
