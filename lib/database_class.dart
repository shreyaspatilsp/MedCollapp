import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tbl_loction = 'loction',
    col_Id = 'id',
    col_latitude = 'latitude',
    col_longitude = 'longitude',
    col_countryCode = 'countryCode',
    col_countryName = 'countryName',
    col_isoNumeric = 'isoNumeric',
    col_isoAlpha3 = 'isoAlpha3',
    col_fipsCode = 'fipsCode',
    col_continent = 'continent',
    col_continentName = 'continentName',
    col_capital = 'capital',
    col_areaInSqKm = 'areaInSqKm',
    col_population = 'population',
    col_currencyCode = 'currencyCode',
    col_languages = 'languages',
    col_geonameId = 'geonameId',
    col_postalCodeFormat = 'postalCodeFormat',
    col_base = 'base',
    col_date = 'date',
    col_west = 'west',
    col_north = 'north',
    col_east = 'east',
    col_south = 'south',
    col_rates = 'rates';


class Locations {
  int id, loc_isoNumeric, loc_geonameId;

  double loc_lat, loc_long, loc_areaInSqKm, loc_west, loc_north, loc_east, loc_south, loc_rates;

  String loc_countryCode, loc_countryName, loc_isoAlpha3,loc_fipsCode,loc_continent,loc_continentName,
      loc_capital,loc_population,loc_currencyCode,loc_languages,loc_postalCodeFormat, loc_base,loc_date;

  Locations();

  Locations.fromMap(Map<String, dynamic> map) {
    id = map[col_Id];
    loc_lat = map[col_latitude];
    loc_long = map[col_longitude];
    loc_countryCode = map[col_countryCode];
    loc_countryName = map[col_countryName];
    loc_isoNumeric = map[col_isoNumeric];
    loc_isoAlpha3 = map[col_isoAlpha3];
    loc_fipsCode = map[col_fipsCode];
    loc_continent = map[col_continent];
    loc_continentName = map[col_continentName];
    loc_capital = map[col_capital];
    loc_areaInSqKm = map[col_areaInSqKm];
    loc_population = map[col_population];
    loc_currencyCode = map[col_currencyCode];
    loc_languages = map[col_languages];
    loc_geonameId = map[col_geonameId];
    loc_west = map[col_west];
    loc_north = map[col_north];
    loc_east = map[col_east];
    loc_south = map[col_south];
    loc_postalCodeFormat = map[col_postalCodeFormat];
    loc_base = map[col_base];
    loc_date = map[col_date];
    loc_rates = map[col_rates];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      col_latitude: loc_lat,
      col_longitude: loc_long,
      col_countryCode: loc_countryCode,
      col_countryName: loc_countryName,
      col_isoNumeric: loc_isoNumeric,
      col_isoAlpha3: loc_isoAlpha3,
      col_fipsCode: loc_fipsCode,
      col_continent: loc_continent,
      col_continentName: loc_continentName,
      col_capital: loc_capital,
      col_areaInSqKm: loc_areaInSqKm,
      col_population: loc_population,
      col_currencyCode: loc_currencyCode,
      col_languages: loc_languages,
      col_geonameId: loc_geonameId,
      col_west: loc_west,
      col_north: loc_north,
      col_east: loc_east,
      col_south: loc_south,
      col_postalCodeFormat: loc_postalCodeFormat,
      col_base: loc_base,
      col_date: loc_date,
      col_rates: loc_rates
    };
    if (id != null) {
      map[col_Id] = id;
    }
    return map;
  }

}

class DatabaseHelper {

  static final _databaseName = "LocationData.db";
  static final _databaseVersion = 1;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tbl_loction (
                $col_Id INTEGER PRIMARY KEY,
                $col_latitude DOUBLE NOT NULL, 
                $col_longitude DOUBLE NOT NULL, 
                $col_countryCode TEXT NOT NULL, 
                $col_countryName TEXT NOT NULL, 
                $col_isoNumeric INT NOT NULL, 
                $col_isoAlpha3 TEXT NOT NULL, 
                $col_fipsCode TEXT NOT NULL, 
                $col_continent TEXT NOT NULL, 
                $col_continentName TEXT NOT NULL, 
                $col_capital TEXT NOT NULL, 
                $col_areaInSqKm DOUBLE NOT NULL, 
                $col_population TEXT NOT NULL, 
                $col_currencyCode TEXT NOT NULL, 
                $col_languages TEXT NOT NULL, 
                $col_geonameId INT NOT NULL, 
                $col_west DOUBLE NOT NULL, 
                $col_north DOUBLE NOT NULL, 
                $col_east DOUBLE NOT NULL, 
                $col_south DOUBLE NOT NULL, 
                $col_postalCodeFormat TEXT NOT NULL, 
                $col_base TEXT NOT NULL, 
                $col_date DATE NOT NULL, 
                $col_rates DOUBLE NOT NULL)
              ''');
  }

  Future<int> insert(Locations word) async {
    Database db = await database;
    int id = await db.insert(tbl_loction, word.toMap());
    return id;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(tbl_loction, orderBy: "$col_Id DESC");
    return res;
  }


  Future<List<Map<String, dynamic>>> querySelectedRow(int id) async {
    Database db = await instance.database;
    var res = await db.query(tbl_loction, where: "$col_Id = $id");
    return res;
  }

  Future<Locations> checkLatLong(double lat, double long) async {
    Database db = await database;
    List<Map> maps = await db.query(tbl_loction,
        columns: [col_Id, col_latitude, col_longitude, col_countryCode, col_countryName,
          col_isoNumeric,col_isoAlpha3,col_fipsCode,col_continent,col_continentName,
          col_capital,col_areaInSqKm,col_population,col_currencyCode,col_languages,
          col_geonameId,col_west,col_north,col_east,col_south,col_postalCodeFormat,
          col_base,col_date,col_rates],
        where: '$col_latitude = ? and $col_longitude = ?',
        whereArgs: [lat,long]);
    if (maps.length > 0) {
      return Locations.fromMap(maps.first);
    }
    return null;
  }
}