import 'package:flutter/material.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/views/widgets/search_widgets/search_result_list_item_tour.dart';

class SearchResultListTour extends StatelessWidget {
  final Stream stream;
  final String value;
  SearchResultListTour(this.stream, this.value);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Tour>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<Tour>> snapshot) {
        if (snapshot.hasData) {
          final _tours = snapshot.data;

          List<Tour> _searchedTour = _tours.where((hotel) {
            final _splittedHotel = hotel.name.toLowerCase().split(' ');
            final _splittedValue = value.toLowerCase().split(' ');

            for (var item in _splittedValue) {
              return _splittedHotel.contains(item);
            }
            return false;
          }).toList();

          final _result = _searchedTour.isEmpty ? _tours : _searchedTour;
          final _count = _result.length;

          return Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              _countAndFilterBuilder(_count),
              _count == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                      child: Text('No result for "$value"'),
                    )
                  : _resultListBuilder(_result),
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
            '$count hotels found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          // GestureDetector(
          //   onTap: () {},
          //   child: Container(
          //     color: Colors.transparent,
          //     child: Row(
          //       children: [
          //         Text(
          //           'Filter',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 12.0,
          //           ),
          //         ),
          //         SizedBox(
          //           width: 10.0,
          //         ),
          //         Icon(
          //           Icons.filter_list,
          //           size: 20.0,
          //           color: Color(0xff45ad90),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _resultListBuilder(final List<Tour> tours) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        return SearchResultListItemTour(tours[index]);
      },
    );
  }
}
