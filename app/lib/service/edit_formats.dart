class EditFormats {
  // class to update formats in a set way

  // format coords to lat doubles separately
  double getLatitude(String coords) {
    // Assuming the format of coords is "lat,lng"
    List<String> parts = coords.split(',');
    if (parts.length != 2) {
      throw const FormatException('Invalid coordinates format');
    }
    return double.parse(parts[0]);
  }

  // format coords to  long doubles separately
  double getLongitude(String coords) {
    // Assuming the format of coords is "lat,lng"
    List<String> parts = coords.split(',');
    if (parts.length != 2) {
      throw const FormatException('Invalid coordinates format');
    }
    return double.parse(parts[1]);
  }
  // format time stamp, hh:mm:ss dd-mm-yyyy
    String formatTimestamp(DateTime timestamp) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:'
             '${timestamp.minute.toString().padLeft(2, '0')}:'
             '${timestamp.second.toString().padLeft(2, '0')} '
             '${timestamp.day.toString().padLeft(2, '0')}-'
             '${timestamp.month.toString().padLeft(2, '0')}-'
             '${timestamp.year.toString()}';
    }
  }