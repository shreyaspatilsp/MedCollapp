import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:untitled1/all_data.dart';
import 'package:untitled1/database_class.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(title: 'Assignment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int isoNumeric, geonameId;
  double lat, long, areaInSqKm, west, north, east, south, rates;
  var location1, geonames,
      country,
      countryCode,
      countryName,
      isoAlpha3,
      fipsCode,
      continent,
      continentName,
      capital,
      population,
      currencyCode,
      languages,
      postalCodeFormat, base, date;
  bool result;

  getAPIData() async {

  final location = Location();
  location1 = await location.getLocation();

  result = await InternetConnectionChecker().hasConnection;
  if(result == true) {
    _showToast(context, 'Loading...', 5);
    lat = location1.latitude;
    long = location1.longitude;
    final LatLongAPI = await http.get(Uri.parse(
        'http://api.geonames.org/countryCode?lat=${location1.latitude}&lng=${location1.longitude}&username=medcollapp'));

    if (LatLongAPI.statusCode == 200) {
      final CountryCodeAPI = await http.get(Uri.parse(
          'http://api.geonames.org/countryInfo?country=${LatLongAPI.body.trim()}&username=medcollapp'));

      if (CountryCodeAPI.statusCode == 200) {
        final document = XmlDocument.parse('''
        ${CountryCodeAPI.body.trim()}
        ''');

        final geonames = document.findElements('geonames').first;
        final country = geonames.findElements('country').first;
        setState(() {
          countryCode = country.findElements('countryCode').first.text;
          countryName = country.findElements('countryName').first.text;
          isoNumeric = int.parse(country.findElements('isoNumeric').first.text);
          isoAlpha3 = country.findElements('isoAlpha3').first.text;
          fipsCode = country.findElements('fipsCode').first.text;
          continent = country.findElements('continent').first.text;
          continentName = country.findElements('continentName').first.text;
          capital = country.findElements('capital').first.text;
          areaInSqKm = double.parse(country.findElements('areaInSqKm').first.text);
          population = country.findElements('population').first.text;
          currencyCode = country.findElements('currencyCode').first.text;
          languages = country.findElements('languages').first.text;
          geonameId = int.parse(country.findElements('geonameId').first.text);
          west = double.parse(country.findElements('west').first.text);
          north = double.parse(country.findElements('north').first.text);
          east = double.parse(country.findElements('east').first.text);
          south = double.parse(country.findElements('south').first.text);
          postalCodeFormat = country.findElements('postalCodeFormat').first.text;
        });

        var CurrencyCodeAPI = await http.get(Uri.parse(
            'https://api.exchangerate.host/latest?base=USD&symbols=${currencyCode.trim()}&amount=1&places=2'));

        if (CurrencyCodeAPI.statusCode == 200) {
          String name, username, avatar;
          var responseJSON = json.decode(CurrencyCodeAPI.body);
          setState(() {
            base=responseJSON['base'];
            date=responseJSON['date'];
            rates=responseJSON['rates']['INR'];
            _read();
          });
        } else throw Exception('error on json data read');

      }
    } else {
      throw Exception('Failed to load post');
    }

  } else {
    _showToast(context,'No internet connection', 1);
    print(InternetConnectionChecker().connectionStatus);
  }

}

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _showToast(context,'Press Again to Exit', 1);
      return Future.value(false);
    }
    return Future.value(true);
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    if(_index == 1) {
      Future.delayed(Duration(milliseconds: 100), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AllDataPage()),
                (route) => false);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      WillPopScope(
          child: countryCode == null || result != true ?
          Center(
            child:Tooltip(message: "Get Location",
                child:OutlinedButton(
                  onPressed: () {
                    getAPIData();
                  },
                  child: Text('Get Location'),
                ),
          ),):
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${countryName == ''? '': countryName} (${countryCode == ''? '': countryCode})',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 20),
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                '${continentName == ''? '': continentName} (${continent == ''? '': continent})',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: 'Cairo',
                                    fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          Container(
                            height: 15,
                          ),
                          Text(
                            'Capital: ${capital == ''? '': capital}\n'
                            'Currency Code: ${currencyCode == ''? '': currencyCode}\n'
                            'ISO Numeric: ${isoNumeric == ''? '': isoNumeric}\n'
                            'ISO Alpha3: ${isoAlpha3 == ''? '': isoAlpha3}\n'
                            'FIPS Code: ${fipsCode == ''? '': fipsCode}\n'
                            'Area in Square KM: ${areaInSqKm == ''? '': areaInSqKm}\n'
                            'Population: ${population == ''? '': population}\n'
                            'Languages: ${languages == ''? '': languages}\n'
                            'geonameId: ${geonameId == ''? '': geonameId}\n'
                            'west: ${west == ''? '': west}\n'
                            'north: ${north == ''? '': north}\n'
                            'east: ${east == ''? '': east}\n'
                            'south: ${south == ''? '': south}\n'
                            'postalCodeFormat: ${postalCodeFormat == ''? '': postalCodeFormat}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Cairo',
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${base == ''? '': base} - ${currencyCode == ''? '': currencyCode}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 20),
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                '${date == ''? '': date}',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: 'Cairo',
                                    fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          Container(
                            height: 15,
                          ),
                          Text(

                            'Currency Rate: ${rates == ''? '': rates}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Cairo',
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onWillPop: onWillPop),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int index) => setState(() => _index = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Current Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Locations you Visited',
          ),
        ],
      ),
    );

  }


  _save() async {
    Locations loc = Locations();

    loc.loc_lat = lat == null ? 0.0 : lat;
    loc.loc_long = long == null ? 0.0 : long;
    loc.loc_countryCode = '$countryCode' == null ? '-' : '$countryCode';
    loc.loc_countryName = '$countryName' == null ? '-' : '$countryName';
    loc.loc_isoNumeric = isoNumeric == null ? 0 : isoNumeric;
    loc.loc_isoAlpha3 = '$isoAlpha3' == null ? '-' : '$isoAlpha3';
    loc.loc_fipsCode = '$fipsCode' == null ? '-' : '$fipsCode';
    loc.loc_continent = '$continent' == null ? '-' : '$continent';
    loc.loc_continentName = '$continentName' == null ? '-' : '$continentName';
    loc.loc_capital = '$capital' == null ? '-' : '$capital';
    loc.loc_areaInSqKm = areaInSqKm == null ? 0.0 : areaInSqKm;
    loc.loc_population = '$population' == null ? '-' : '$population';
    loc.loc_currencyCode = '$currencyCode' == null ? '-' : '$currencyCode';
    loc.loc_languages = '$languages' == null ? '-' : '$languages';
    loc.loc_geonameId = geonameId == null ? 0 : geonameId;
    loc.loc_west = west == null ? 0.0 : west;
    loc.loc_north = north == null ? 0.0 : north;
    loc.loc_east = east == null ? 0.0 : east;
    loc.loc_south = south == null ? 0.0 : south;
    loc.loc_postalCodeFormat = '$postalCodeFormat' == null ? '-' : '$postalCodeFormat';
    loc.loc_base = '$base' == null ? '-' : '$base';
    loc.loc_date = '$date' == null ? '-' : '$date';
    loc.loc_rates = rates == null ? 0.0 : rates;

    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(loc);
    _showToast(context, 'Record Saved Successfully', 2);
  }



  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    Locations loc = await helper.checkLatLong(lat, long);
    if (loc == null) {
      _save();
    } else {
      if(loc.loc_lat == lat && loc.loc_long == long){
        _showToast(context, 'Location already Available', 1);
      }else {
        _save();
      }
    }
  }

  void _showToast(BuildContext context, String msg, int time) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(duration: Duration(seconds: time),
        content: Text(msg),
      ),
    );
  }
}
