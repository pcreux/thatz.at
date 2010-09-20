function tz_code() {
  // from http://www.onlineaspect.com/2007/06/08/auto-detect-a-time-zone-with-javascript
  var rightNow = new Date();
  var jan1 = new Date(rightNow.getFullYear(), 0, 1, 0, 0, 0, 0);
  var temp = jan1.toGMTString();
  var jan2 = new Date(temp.substring(0, temp.lastIndexOf(" ")-1));
  var std_time_offset = (jan1 - jan2) / (1000 * 60 * 60);
  var june1 = new Date(rightNow.getFullYear(), 6, 1, 0, 0, 0, 0);
  temp = june1.toGMTString();
  var june2 = new Date(temp.substring(0, temp.lastIndexOf(" ")-1));
  var daylight_time_offset = (june1 - june2) / (1000 * 60 * 60);
  var dst;
  if (std_time_offset == daylight_time_offset) {
      dst = ""; // daylight savings time is NOT observed
  } else {
      dst = "-DST"; // daylight savings time is observed
  }
  // Add a '+' for positive numbers
  if (std_time_offset >= 0) {
    std_time_offset = "+" + std_time_offset
  }
  return "GMT" + std_time_offset + dst
}
