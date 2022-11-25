import 'package:flutter/material.dart';
import 'database_class.dart';
import 'main.dart';

class AllDataPage extends StatefulWidget {
  @override
  State<AllDataPage> createState() => AllDataPage1();
}

class Listing_Data {
  final String countryvalue,capital;
  final int id;
  Listing_Data({this.id, this.countryvalue, this.capital});
}

List<Listing_Data> taskList = new List();
class AllDataPage1 extends State<AllDataPage> {

  @override
  void initState() {
    super.initState();

    taskList = [];
    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
          value.forEach((element) {
            taskList.add(Listing_Data(id: element['id'],
                countryvalue: element['countryName'],
                capital: element['capital']),
            );
          });
      });
    }).catchError((error) {
      print(error);
      _showToast(context,'Something went Wrong!', 1);
    });
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

  int _index1 = 1;
  @override
  Widget build(BuildContext context) {

    if(_index1 == 0) {
        Future.delayed(Duration(milliseconds: 100), (){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyApp()),
                  (route) => false);
        });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Locations you Visited'),
      ),
      body: WillPopScope(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: taskList.isEmpty
                ? Center(child: Text('No Records'),)
                : Container(
                    child: ListView.builder(itemBuilder: (ctx, index) {
                      if (index == taskList.length) return null;
                      return ListTile(
                          leading: Icon(Icons.remove_red_eye),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Country Name'),
                              Text('${taskList[index].countryvalue}'),
                            ],
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Capital'),
                                  Text('${taskList[index].capital}'),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                          focusColor: Colors.grey,
                          onTap: () {
                            getDBData(taskList[index].id);
                            Future.delayed(Duration(milliseconds: 100), () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => SingleDataPage()),
                                  (route) => true);
                            });
                          },
                        );
                    }),
                  ),
          ),
          onWillPop: onWillPop),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index1,
        onTap: (int index) => setState(() => _index1 = index),
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

  void _showToast(BuildContext context, String msg, int time) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(duration: Duration(seconds: time),
        content: Text(msg),
      ),
    );
  }

}




class SingleDataPage extends StatefulWidget {
  const SingleDataPage({Key key, this.id}) : super(key: key);
  final int id;

  @override
  State<SingleDataPage> createState() => SingleDataPage1();
}


var lat, long, areaInSqKm, west,
    north, east, south, rates, isoNumeric, geonameId,
    country,  countryCode, countryName, isoAlpha3,
    fipsCode, continent, continentName, capital,  population,
    currencyCode, languages, postalCodeFormat, base, date;

getDBData(int id) async{
  searchTerms =[];

  DatabaseHelper.instance.querySelectedRow(id).then((value) async{

      lat = await value.single['latitude'].toString();
      long = await value.single['longitude'].toString();
      countryCode = await value.single['countryCode'].toString();
      countryName = await value.single['countryName'].toString();
      isoNumeric = await value.single['isoNumeric'].toString();
      isoAlpha3 = await value.single['isoAlpha3'].toString();
      fipsCode = await value.single['fipsCode'].toString();
      continent = await value.single['continent'].toString();
      continentName = await value.single['continentName'].toString();
      capital = await value.single['capital'].toString();
      areaInSqKm = await value.single['areaInSqKm'].toString();
      population = await value.single['population'].toString();
      currencyCode = await value.single['currencyCode'].toString();
      languages = await value.single['languages'].toString();
      geonameId = await value.single['geonameId'].toString();
      west = await value.single['west'].toString();
      north = await value.single['north'].toString();
      east = await value.single['east'].toString();
      south = await value.single['south'].toString();
      postalCodeFormat = await value.single['postalCodeFormat'].toString();
      date = await value.single['date'].toString();
      rates = await value.single['rates'].toString();
      base = await value.single['base'].toString();

      searchTerms.add('latitude: '+lat);
      searchTerms.add('longitude: '+long);
      searchTerms.add('Country Code: '+countryCode);
      searchTerms.add('Country Name: '+countryName);
      searchTerms.add('ISO Numeric: '+isoNumeric);
      searchTerms.add('ISO Alpha3: '+isoAlpha3);
      searchTerms.add('fips Code: '+fipsCode);
      searchTerms.add('Continent: '+continent);
      searchTerms.add('Continent Name: '+continentName);
      searchTerms.add('Capital: '+capital);
      searchTerms.add('Area In SqKm: '+areaInSqKm);
      searchTerms.add('Population: '+population);
      searchTerms.add('Currency Code: '+currencyCode);
      searchTerms.add('Languages: '+languages);
      searchTerms.add('GeonameId: '+geonameId);
      searchTerms.add('West: '+west);
      searchTerms.add('North: '+north);
      searchTerms.add('East: '+east);
      searchTerms.add('South: '+south);
      searchTerms.add('Postal Code Format: '+postalCodeFormat);
      searchTerms.add('Date: '+date);
      searchTerms.add('Rates: '+rates);

  }).catchError((error) {
    print(error);
  });

}



class SingleDataPage1 extends State<SingleDataPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${countryName}'),
        actions: [
          Tooltip(message: "Search",
            child:TextButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchOption()
                );
              },
              child: Icon(Icons.search, color: Colors.white,),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:  Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(5),
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
                                '${countryName} (${countryCode})',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 20),
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                '${continentName} (${continent})',
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
                            'Capital: ${capital}\n'
                                'Currency Code: ${currencyCode}\n'
                                'ISO Numeric: ${isoNumeric}\n'
                                'ISO Alpha3: ${isoAlpha3}\n'
                                'FIPS Code: ${fipsCode}\n'
                                'Area in Square KM: ${areaInSqKm}\n'
                                'Population: ${population}\n'
                                'Languages: ${languages}\n'
                                'geonameId: ${geonameId}\n'
                                'west: ${west}\n'
                                'north: ${north}\n'
                                'east: ${east}\n'
                                'south: ${south}\n'
                                'postalCodeFormat: ${postalCodeFormat}',
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
                                '${base} - ${currencyCode}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 20),
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                '${date}',
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

                            'Currency Rate: ${rates}',
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
        ),
      ),
    );
  }

}

List<String> searchTerms = [];
class SearchOption extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}


