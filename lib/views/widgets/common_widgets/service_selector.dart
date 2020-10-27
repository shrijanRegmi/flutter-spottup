import 'package:flutter/material.dart';
import 'package:motel/enums/booking_for_type.dart';

class ServiceSelector extends StatefulWidget {
  final Function(BookingForType) onSelected;
  ServiceSelector({this.onSelected});

  @override
  _ServiceSelectorState createState() => _ServiceSelectorState();
}

class _ServiceSelectorState extends State<ServiceSelector> {
  BookingForType _service = BookingForType.hotel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            widget.onSelected(BookingForType.hotel);
            setState(() {
              _service = BookingForType.hotel;
            });
          },
          child: _selectorItem(
            Icons.hotel,
            'Hotels',
            _service == BookingForType.hotel,
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.onSelected(BookingForType.tour);
            setState(() {
              _service = BookingForType.tour;
            });
          },
          child: _selectorItem(
            Icons.card_travel,
            'Tours',
            _service == BookingForType.tour,
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.onSelected(BookingForType.vehicle);
            setState(() {
              _service = BookingForType.vehicle;
            });
          },
          child: _selectorItem(
            Icons.directions_bus,
            'Bus/Car',
            _service == BookingForType.vehicle,
          ),
        ),
      ],
    );
  }

  Widget _selectorItem(
      final IconData _icon, final String _title, final bool _isSelected) {
    return Column(
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: _isSelected ? Color(0xff45ad90) : Colors.transparent,
            border: Border.all(
              color: Color(0xff45ad90),
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              _icon,
              color: _isSelected ? Colors.white : Color(0xff45ad90),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          '$_title',
          style: TextStyle(
            color: Color(0xff45ad90),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
