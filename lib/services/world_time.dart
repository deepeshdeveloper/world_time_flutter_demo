import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {
  late String location; // location name for UI
  late String time; // time in that location
  late String flag; // url to an asset flag icon
  late String url; // location URL for api endpoints
  late bool isDayTime; // true or false if daytime or not

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      // make the request
      Response response =
          await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);
      //print(data);

      // get properties from data
      String dateTime = data['datetime'];
      String offset = data['utc_offset'];
      String timeToAdd = offset.substring(1, 3);
      //print(dateTime);
      //print(timeToAdd);

      // create a DateTime object
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: int.parse(timeToAdd)));

      // set the time property
      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('caught error: $e');
      time = 'could not get time data';
    }
  }
}
