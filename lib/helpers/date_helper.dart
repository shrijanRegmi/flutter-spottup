class DateHelper {
  String getFormattedDate(int milliseconds) {
    final _date = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    final _result = '${_getMonth(_date.month)} ${_date.day}, 2020 ';
    return _result;
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
      default:
        return 'Jan';
    }
  }
}
