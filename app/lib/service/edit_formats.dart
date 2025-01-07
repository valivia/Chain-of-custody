class EditFormats {
  // class to update formats in a set way


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