import 'package:flutter/material.dart';
import 'package:motel/views/widgets/tours_tab_widgets/add_new_tour.dart';
import 'package:motel/views/widgets/tours_tab_widgets/partner_tours_list.dart';

class ToursTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _addNewTourBuilder(context),
          PartnerToursList(isEditing: true),
        ],
      ),
    );
  }

  Widget _addNewTourBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddNewTour(),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Color(0xff45ad90),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Color(0xff45ad90),
                  size: 50.0,
                ),
                Text(
                  'Add a new tour',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color(0xff45ad90),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
