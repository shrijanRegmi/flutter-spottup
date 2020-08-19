import 'package:flutter/material.dart';
import 'package:motel/views/widgets/search_widgets/search_result_list_item.dart';

class SearchResultList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.0,
        ),
        _countAndFilterBuilder(),
        _resultListBuilder(),
      ],
    );
  }

  Widget _countAndFilterBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '20 hotels found',
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

  Widget _resultListBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return SearchResultListItem();
      },
    );
  }
}
